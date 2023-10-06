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
      def add(spaciable_doc)



      end

      private

      def add_document(spaciable_doc)
        retries = 0
        document = nil

        begin

          spaciable_doc.programs.each do | program |
          end

          response = HTTParty.post("#{EnvVar[:unlatch_url]}lot/#{plot.unlatch_program_id}/#{id}/document/",
                                   body:
                                     {
                                       file: spaciable_doc.source,
                                       caption: spaciable_doc.title,
                                       documentType: "brochure"
                                     },
                                   headers:
                                     {
                                       "Accept" => "application/json",
                                       "Authorization" => "Bearer #{EnvVar[:unlatch_token, true]}"
                                     },
                                   timeout: 10)
          if response.code == 200
            document_id = response.parsed_response["documentId"]
            document = Unlatch::Document.create(id: document_id,
                                                documentable: spaciable_doc,
                                                doc_type: :document,
                                                unlatch_lot_id: id)
          elsif response.code == 401 && retries.zero?
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
