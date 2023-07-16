# frozen_string_literal: true

module Unlatch
  class Developer
    # rubocop:disable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
    # rubocop:disable Style/RaiseArgs
    class << self
      def list
        retries = 0
        developers = error = nil

        begin
          response = HTTParty.get("#{EnvVar[:unlatch_url]}developers",
                                  headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json",
                                      "Authorization" => "Bearer #{EnvVar[:unlatch_token, true]}"
                                    },
                                  timeout: 10)
          if response.code == 200
            developers = response.parsed_response.map { |h| [h["caption"], h["id"]] }
          elsif response.code == 401 && retries.zero?
            Unlatch::Token.set
            retries += 1
            raise Unlatch::Unauthorised.new
          else
            Rails.logger.error("UNLATCH: Failed to obtain Developers - " \
                               "status #{response.code}")
          end
        rescue Unlatch::Unauthorised
          retry
        rescue Net::OpenTimeout
          Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
        rescue => e
          Rails.logger.error("UNLATCH: Failed to retrieve Developers - #{e.message}")
        end

        developers
      end
    end
    # rubocop:enable Style/RaiseArgs
    # rubocop:enable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
  end
end
