# frozen_string_literal: true

class Uniqodo
  include HTTParty

  # class constants
  API_KEY = ENV.fetch("UNIQODO_API_KEY")
  OFFER_CODE = "13482"
  TIMEOUT = 10
  CONNECT_ERROR = "Failed to redeem offer. Please try again later."
  VERIFY = false

  def self.redeem(uid)
    offer_url = error = nil

    begin
      response = HTTParty.get("http://api.uniqodo.com/code/#{API_KEY}/#{OFFER_CODE}?uid=#{uid}",
                              timeout: TIMEOUT, verify: VERIFY)

      return CONNECT_ERROR, nil unless response.code == 200
      if response.parsed_response["result"] == "success"
        offer_url = response.parsed_response["data"]["url"]
      else
        error = response.parsed_response["errors"][0]["message"]
      end
    rescue
      error = CONNECT_ERROR
    end

    return error, offer_url
  end
end
