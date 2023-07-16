# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:disable Style/RaiseArgs, Metrics/LineLength
  class Document < ApplicationRecord
    self.table_name = "unlatch_documents"

    belongs_to :unlatch_lot, class_name: "Unlatch::Lot"
    belongs_to :document

    delegate :unlatch_program_id, to: :unlatch_lot

    before_destroy :remove

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
