# frozen_string_literal: true

module Unlatch
  class Developer < ApplicationRecord
    self.table_name = "unlatch_developers"

    belongs_to :developer, class_name: "::Developer"
    has_many :programs, class_name: "Unlatch::Program"
    has_many :sections, class_name: "Unlatch::Section"

    # rubocop:disable Metrics/MethodLength
    def refresh_token
      begin
        response = HTTParty.post("#{api}key/",
                                 body:
                                  {
                                    email:    email,
                                    password: password
                                  }.to_json,
                                 headers:
                                  {
                                    "Content-Type" => "application/json",
                                    "Accept" => "application/json"
                                  },
                                 timeout: 10)

        if response.code == 200
          self.token = response.parsed_response["token"]
          self.expires = response.parsed_response["expiration"]
          save
        else
          Rails.logger.error("Failed to obtain Uplatch token - status #{response.code}")
        end
      rescue Net::OpenTimeout
        Unlatch::Log.add(nil, "#{__method__} Failed to obtain Uplatch token - status #{response.code}")
      rescue => e
        Unlatch::Log.add(nil, "UNLATCH: #{__method__} Failed to retrieve token - #{e.message}")
      end

      token
    end
    # rubocop:enable Metrics/MethodLength
  end
end
