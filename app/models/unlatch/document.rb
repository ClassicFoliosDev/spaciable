# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:disable Style/RaiseArgs, Metrics/LineLength
  class Document < ApplicationRecord
    self.table_name = "unlatch_documents"

    belongs_to :document, class_name: "::Document"
    belongs_to :program, class_name: "Unlatch::Program"
    belongs_to :section, class_name: "Unlatch::Section"
    delegate :developer, to: :program

    before_destroy :DELETE

    class << self
      # Add the document
      def add(spaciable_doc, programs = nil)
        # docs can be applicable to multiple developments, and therefore 
        # multiple programs
        (programs || spaciable_doc.documentable.programs).each do | program |
          POST(spaciable_doc,
                 program,
                 spaciable_doc.lots,
                 Unlatch::Section.find_by(developer_id: spaciable_doc.unlatch_developer.id,
                                          category: spaciable_doc.category))
        end
      end

      private

      def POST(spaciable_doc, program, lots, section)
        retries = 0
        document = nil
        developer = spaciable_doc.unlatch_developer;

        return unless developer.present?

        body = {
                 "file" => spaciable_doc.source,
                 "caption" => spaciable_doc.title,
                 "section" => section&.id,
                 "documentType" => "brochure"
               }

        # API only accepts lots if populated :(
        body[:lots] = lots if lots&.any?

        begin
          response = HTTParty.post("#{developer.api}programs/#{program.id}/document/",
                                   body: body,
                                   headers:
                                     {
                                       "Accept" => "application/json",
                                       "Authorization" => "Bearer #{developer.token}"
                                     },
                                   timeout: 10)
          if response.code == 200
            document_id = response.parsed_response["documentId"]
            document = Unlatch::Document.create(id: document_id,
                                                document_id: spaciable_doc.id,
                                                program_id: program.id,
                                                section_id: section&.id)
          elsif response.code == 401 && retries.zero?
            developer.refresh_token
            retries += 1
            raise Unlatch::Unauthorised.new
          else
            Rails.logger.error("UNLATCH: Failed to  add document #{spaciable_doc.id} - " \
                               "status #{response.code}")
          end
        rescue Unlatch::Unauthorised
          retry
        rescue Net::OpenTimeout
          byebug
          Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
        rescue => e
          byebug
          Rails.logger.error("UNLATCH: Failed to POST document - #{e.message}")
        end

        document
      end
    end

    # remove document from unlatch
    def DELETE
      retries = 0

      begin
        response = HTTParty.delete("#{developer.api}programs/#{program.id}/documents/#{id}/",
                                   headers:
                                     {
                                       "Content-Type" => "application/json",
                                       "Accept" => "application/json",
                                       "Authorization" => "Bearer #{developer.token}"
                                     },
                                   timeout: 10)
        return if response.code == 200
        if response.code == 401 && retries.zero?
          developer.refresh_token
          retries += 1
          raise Unlatch::Unauthorised.new
        else 
          Rails.logger.error("UNLATCH: Failed to obtain DELETE document #{document.id} - " \
                             "status #{response.code}")
        end
      rescue Unlatch::Unauthorised
        retry
      rescue Net::OpenTimeout
        Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
      rescue => e
        Rails.logger.error("UNLATCH: Failed to DELETE Document - #{e.message}")
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:enable Style/RaiseArgs, Metrics/LineLength
end
