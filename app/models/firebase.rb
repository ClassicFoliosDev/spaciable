# frozen_string_literal: true

# rubocop:disable all
class Firebase
  include HTTParty

  # class constants
  URL = EnvVar[:firebase_url]
  TIMEOUT = 10
  TIMEOUT_ERROR = "#{URL} is currently unavaliable. Please try again later"
  CONNECT_ERROR = "#{URL} cannot be contacted"

  class << self

    def shorten(link)

      url = "#{URL}#{EnvVar[:firebase_shorten_endpoint]}" +
            "?key=#{EnvVar[:firebase_api_key]}"
      begin
        response = HTTParty.post(url,
          body:
            {
              longDynamicLink: EnvVar[:firebase_living_domain] +
                               "/?link=" + ERB::Util.url_encode(link) +
                               EnvVar[:living_deep_link]
            }.to_json,
          headers:
            {
              "Content-Type" => "application/json",
              "Accept" => "application/json"
            },

          timeout: TIMEOUT)

        shortlink = error = nil
        if response.code == 200
          shortlink = response.parsed_response["shortLink"]
        else
          error = "Failed to create shortend url. #{response.parsed_response['errors']}"
        end
      rescue Net::OpenTimeout
        error = TIMEOUT_ERROR
      rescue
        error = CONNECT_ERROR
      end

      yield shortlink, error
    end
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable all
