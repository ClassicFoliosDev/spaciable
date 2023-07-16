# frozen_string_literal: true

module Unlatch
  class Token
    include HTTParty

    TIMEOUT_ERROR = "Uplatch is currently unavaliable. Please try again later"

    class << self
      # rubocop:disable Metrics/MethodLength
      def set
        begin
          response = HTTParty.post("#{EnvVar[:unlatch_url]}key/",
                                   body:
                                    {
                                      email:    EnvVar[:unlatch_email],
                                      password: EnvVar[:unlatch_password]
                                    }.to_json,
                                   headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json"
                                    },
                                   timeout: 10)

          key = nil
          if response.code == 200
            key = response.parsed_response["token"]
            EnvVar.update(:unlatch_token, key)
          else
            Rails.logger.error("Failed to obtain Uplatch key - status #{response.code}")
          end
        rescue Net::OpenTimeout
          Rails.logger.error("Failed to obtain Uplatch key - status #{response.code}")
        rescue => e
          Rails.logger.error("UNLATCH: Failed to retrieve token - #{e.message}")
        end

        key
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
