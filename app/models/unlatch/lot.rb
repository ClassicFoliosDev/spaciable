# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:disable Style/RaiseArgs, Metrics/LineLength
  class Lot < ApplicationRecord
    self.table_name = "unlatch_lots"

    belongs_to :plot
    has_many :unlatch_documents, class_name: "Unlatch::Document", dependent: :destroy
    delegate :unlatch_program_id, to: :plot

    enum sync_status: %i[
      unsynchronised
      synchronised
      failed_to_synchronise
    ]

    class << self
      # Look for a Lot matching the supplied Plot
      def sync(plot)
        retries = 0
        lot = nil

        begin
          response = HTTParty.get("#{EnvVar[:unlatch_url]}lots/",
                                  headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json",
                                      "Authorization" => "Bearer #{EnvVar[:unlatch_token, true]}"
                                    },
                                  timeout: 10)
          if response.code == 200
            lots = response.parsed_response.select { |l| l["programId"] == plot.unlatch_program_id && l["lotNumber"] == plot.number }
            if lots.one?
              lot = Unlatch::Lot.create(id: lots[0]["lotId"],
                                        plot_id: plot.id)
            end
          elsif response.code == 401 && retries.zero?
            Unlatch::Token.set
            retries += 1
            raise Unlatch::Unauthorised.new
          else
            Rails.logger.error("UNLATCH: Failed to obtain Lot with Number #{plot.number} - " \
                               "status #{response.code}")
          end
        rescue Unlatch::Unauthorised
          retry
        rescue Net::OpenTimeout
          Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
        rescue => e
          Rails.logger.error("UNLATCH: Failed to retrieve Lots - #{e.message}")
        end

        lot
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
                                              document: spaciable_doc,
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
