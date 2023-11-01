# frozen_string_literal: true

module Unlatch
  class Program < ApplicationRecord
    self.table_name = "unlatch_programs"

    belongs_to :development, class_name: "::Development"
    belongs_to :developer, class_name: "Unlatch::Developer"
    has_many :documents, class_name: "Unlatch::Document", dependent: :destroy

    scope :in_division,
          lambda { |division|
            joins(:development)
              .where(developments: { division_id: division.id })
          }

    # rubocop:disable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
    # rubocop:disable Style/RaiseArgs, Metrics/LineLength
    class << self
      def list(developer)
        retries = 0
        programs = error = nil

        begin
          response = HTTParty.get("#{developer.api}programs?developerId=#{developer.id}",
                                  headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json",
                                      "Authorization" => "Bearer #{developer.token}"
                                    },
                                  timeout: 10)
          if response.code == 200
            programs = response.parsed_response.map { |p| [p["caption"], p["programId"]] }
          elsif [401, 403].include?(response.code) && retries.zero?
            developer.refresh_token
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
          Rails.logger.error("UNLATCH: Failed to retrieve programs - #{e.message}")
        end

        programs
      end

      # Find the associated Unlatch Program,and if found, create a Spaciable Program.
      # If there are documents at developer/division level, then these also have to be added
      # to the program at this point
      def add(u_developer, s_development)
        unlatch_id = list(u_developer)&.select { |(name, _)| name.casecmp(s_development.name).zero? }&.map { |(_, id)| id }
        return if unlatch_id.blank? || unlatch_id&.empty?
        Unlatch::Program.create(id: unlatch_id[0],
                                development_id: s_development.id,
                                developer_id: u_developer.id)
      end
    end
    # rubocop:enable Style/RaiseArgs, Metrics/LineLength
    # rubocop:enable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
  end
end
