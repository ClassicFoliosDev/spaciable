# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:disable Style/RaiseArgs, Metrics/LineLength
  class Lot < ApplicationRecord

    self.table_name = "unlatch_lots"

    belongs_to :plot, class_name: "::Plot"
    belongs_to :program, class_name: "Unlatch::Program"
    delegate :developer, to: :program

    class << self
      # Look for a Lot matching the supplied Plot
      def lots(program)
        retries = 0
        programs = error = nil

        begin
          response = HTTParty.get("#{program.developer.api}lots/",
                                  headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json",
                                      "Authorization" => "Bearer #{program.developer.token}"
                                    },
                                  timeout: 10)
          if response.code == 200
            lots = response.parsed_response.select { |l| l["programId"] == program.id }
          elsif [403, 401].include?(response.code) && retries.zero?
            program.developer.refresh_token
            retries += 1
            raise Unlatch::Unauthorised.new
          else
            Rails.logger.error("UNLATCH: Failed to obtain Lots - " \
                               "status #{response.code}")
          end
        rescue Unlatch::Unauthorised
          retry
        rescue Net::OpenTimeout
          Rails.logger.error("UNLATCH: Uplatch is currently unavaliable. Please try again later")
        rescue => e
          Rails.logger.error("UNLATCH: Failed to retrieve Lots - #{e.message}")
        end

        lots
      end

      # Find the associated Unlatch Program,and if found, create a child Lot
      def add(plot)
        lot = lots(plot&.program).select { |l| l["lotNumber"] == plot.number }
        return unless lot&.count == 1
        lot = Unlatch::Lot.create(id: lot[0]["lotId"], 
                                  plot_id: plot.id,
                                  program_id: plot.program.id)
        lot.sync_docs
      end
    end

    def sync_docs
    end
  end
  # rubocop:enable Style/RaiseArgs, Metrics/LineLength
  # rubocop:enable Metrics/MethodLength, Lint/UselessAssignment, Metrics/AbcSize
end
