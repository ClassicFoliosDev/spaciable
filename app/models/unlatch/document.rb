# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:disable Style/RaiseArgs, Metrics/LineLength
  class Document < ApplicationRecord
    self.table_name = "unlatch_documents"

    belongs_to :document, class_name: "::Document"
    belongs_to :program, class_name: "Unlatch::Program"
    belongs_to :section, class_name: "Unlatch::Section"

    before_destroy :remove

    class << self
      # Add the documen
      def add(spaciable_doc)
        # docs can be applicable to multiple developments, and therefore 
        # multiple programs
        spaciable_doc.documentable.programs.each do | program |
          add_document(spaciable_doc,
                       program,
                       [32210687],
                       Unlatch::Section.find_by(program_id: program.id,
                                                category: spaciable_doc.category))
        end
      end

      private

      def add_document(spaciable_doc, program, lots, section)
        byebug
        retries = 0
        document = nil
        developer = spaciable_doc&.documentable&.unlatch_developer;

        return unless developer.present?

        begin
          response = HTTParty.post("#{developer.api}programs/#{program.id}/document/",
                                   body:
                                     {
                                       file: spaciable_doc.source,
                                       caption: spaciable_doc.title,
                                       lots: lots,
                                       section: section.id,
                                       documentType: "brochure",
                                       showToBuyer: true
                                     },
                                   headers:
                                     {
                                       "Accept" => "application/json",
                                       "Authorization" => "Bearer #{developer.token}"
                                     },
                                   timeout: 10)
          if response.code == 200
            byebug
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
          Rails.logger.error("UNLATCH: Failed to post document - #{e.message}")
        end

        document
      end
    end

    # remove document from unlatch
    def remove
      retries = 0

      begin
        response = HTTParty.delete("#{EnvVar[:unlatch_url]}lot/#{unlatch_program_id}/#{unlatch_lot.id}/document/#{id}/",
                                   headers:
                                     {
                                       "Content-Type" => "application/json",
                                       "Accept" => "application/json",
                                       "Authorization" => "Bearer #{EnvVar[:unlatch_token, true]}"
                                     },
                                   timeout: 10)
        if response.code == 401 && retries.zero?
          Unlatch::Token.set
          retries += 1
          raise Unlatch::Unauthorised.new
        else
          Rails.logger.error("UNLATCH: Failed to obtain POST document #{document.id} - " \
                             "status #{response.code}")
        end
      rescue Unlatch::Unauthorised
        retry
      rescue Net::OpenTimeout
        Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
      rescue => e
        Rails.logger.error("UNLATCH: Failed to post document - #{e.message}")
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:enable Style/RaiseArgs, Metrics/LineLength
end
