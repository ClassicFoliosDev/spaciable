# frozen_string_literal: true

module Unlatch
  class Program
    # rubocop:disable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
    # rubocop:disable Style/RaiseArgs, Metrics/LineLength
    class << self
      def list(developer)
        retries = 0
        phases = error = nil

        begin
          response = HTTParty.get("#{EnvVar[:unlatch_url]}programs/?developerId=#{developer.unlatch_developer_id}",
                                  headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json",
                                      "Authorization" => "Bearer #{EnvVar[:unlatch_token, true]}"
                                    },
                                  timeout: 10)
          if response.code == 200
            phases = response.parsed_response.map { |p| [p["caption"], p["programId"]] }
          elsif response.code == 401 && retries.zero?
            Unlatch::Token.set
            retries += 1
            raise Unlatch::Unauthorised.new
          else
            Rails.logger.error("UNLATCH: Failed to obtain Programs - " \
                               "status #{response.code}")
          end
        rescue Unlatch::Unauthorised
          retry
        rescue Net::OpenTimeout
          Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
        rescue => e
          Rails.logger.error("UNLATCH: Failed to retrieve Phases - #{e.message}")
        end

        phases
      end
    end
    # rubocop:enable Style/RaiseArgs, Metrics/LineLength
    # rubocop:enable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
  end
end
