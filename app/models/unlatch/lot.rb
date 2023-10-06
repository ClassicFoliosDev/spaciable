# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:disable Style/RaiseArgs, Metrics/LineLength
  class Lot < ApplicationRecord

    self.table_name = "unlatch_lots"

    belongs_to :plot, class_name: "::Plot"
    belongs_to :program, class_name: "Unlatch::Program"

    class << self
      # Look for a Lot matching the supplied Plot
      def lots(program)
        retries = 0
        programs = error = nil

        begin
          response = HTTParty.get("#{program.developer.api}lots/",
                                  headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json",
                                      "Authorization" => "Bearer #{program.developer.token}"
                                    },
                                  timeout: 10)
          if response.code == 200
            lots = response.parsed_response.select { |l| l["programId"] == program.id }
          elsif [403, 401].include?(response.code) && retries.zero?
            program.developer.refresh_token
            retries += 1
            raise Unlatch::Unauthorised.new
          else
            Rails.logger.error("UNLATCH: Failed to obtain Lots - " \
                               "status #{response.code}")
          end
        rescue Unlatch::Unauthorised
          retry
        rescue Net::OpenTimeout
          Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
        rescue => e
          Rails.logger.error("UNLATCH: Failed to retrieve Lots - #{e.message}")
        end

        lots
      end

      # Find the associated Unlatch Program,and if found, create a sync marker
      def sync(plot)
        lot = lots(plot.program).select { |l| l["lotNumber"] == plot.number }
        return if lot.blank? || lot&.empty? || lot.count != 1
        Unlatch::Lot.create(id: lot[0]["lotId"], 
                                plot_id: plot.id,
                                program_id: plot.program.id)

      end
    end

    def add_document(spaciable_doc)
      retries = 0
      document = nil

      begin
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
  # rubocop:enable Style/RaiseArgs, Metrics/LineLength
  # rubocop:enable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
end
