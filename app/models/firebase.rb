# frozen_string_literal: true

# rubocop:disable all
class Firebase
  include HTTParty

  TIMEOUT = 10

  class << self

    def shorten(link)

      url = "#{EnvVar[:firebase_url]}#{EnvVar[:firebase_shorten_endpoint]}" +
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
        error = "#{EnvVar[:firebase_url]} is currently unavaliable. Please try again later"
      rescue
        error = "#{EnvVar[:firebase_url]} cannot be contacted"
      end

      yield shortlink, error
    end
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable all
