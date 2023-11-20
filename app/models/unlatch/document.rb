# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
  # rubocop:disable Style/RaiseArgs, Naming/MethodName, Metrics/CyclomaticComplexity
  class Document < ApplicationRecord
    self.table_name = "unlatch_documents"

    belongs_to :document, class_name: "::Document"
    belongs_to :program, class_name: "Unlatch::Program"
    belongs_to :section, class_name: "Unlatch::Section"
    delegate :developer, to: :program

    before_destroy :DELETE

    class << self
      # The interface uses POST to both ADD and UPDATE a document.  This
      # function needs to cover both cases.
      def sync(spaciable_doc)
        # docs can be applicable to multiple developments, and therefore
        # multiple programs
        spaciable_doc.documentable.programs.each do |program|
          POST(spaciable_doc, program)
        end
      end

      private

      # rubocop:disable LineLength, Style/RescueStandardError
      def POST(spaciable_doc, program)
        retries = 0
        developer = spaciable_doc.unlatch_developer
        # Find the id of the existing document if there is one
        document = Unlatch::Document.find_by(program_id: program.id,
                                             document_id: spaciable_doc.id)

        return if developer.blank?

        begin
          body = {
            "file" => spaciable_doc.source,
            "caption" => spaciable_doc.title,
            "documentType" => "brochure",
            "showToBuyers" => true
          }

          # API only accepts lots and section if populated :(
          body[:lots] = spaciable_doc.lots if spaciable_doc.lots&.any?
          body[:section] = spaciable_doc.section.id if spaciable_doc.section&.present?
          body[:documentId] = document.id unless document.nil?

          response = HTTParty.post("#{developer.api}programs/#{program.id}/document/",
                                   body: body,
                                   headers:
                                     {
                                       "Accept" => "application/json",
                                       "Authorization" => "Bearer #{developer.token}"
                                     },
                                   timeout: 10)
          if response.code == 200
            return document unless document.nil? # updated, not new

            document_id = response.parsed_response["documentId"]
            document = Unlatch::Document.create(id: document_id,
                                                document_id: spaciable_doc.id,
                                                program_id: program.id,
                                                section_id: spaciable_doc&.section&.id)
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
          Unlatch::Log.add(spaciable_doc, "UNLATCH: #{__method__} Uplatch is currently unavaliable. Please try again later")
        rescue => e
          Unlatch::Log.add(spaciable_doc, "UNLATCH: #{__method__} Failed to POST document - #{e.message}")
        end

        document
      end
    end
    # rubocop:enable LineLength, Style/RescueStandardError

    # remove document from unlatch
    # rubocop:disable Style/RescueStandardError
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
    # rubocop:enable Style/RescueStandardError
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
  # rubocop:enable Style/RaiseArgs, Naming/MethodName, Metrics/PerceivedComplexity
end
