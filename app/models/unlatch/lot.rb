# frozen_string_literal: true

module Unlatch
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # rubocop:disable Style/RaiseArgs, Metrics/LineLength, Style/RescueStandardError
  class Lot < ApplicationRecord
    self.table_name = "unlatch_lots"

    belongs_to :plot, class_name: "::Plot"
    belongs_to :program, class_name: "Unlatch::Program"
    delegate :developer, to: :program
    after_destroy :resync_containers

    scope :in_phase,
          lambda { |phase|
            joins(plot: :phase).where(phases: { id: phase.id })
          }

    scope :with_unit_type,
          lambda { |unit_type|
            joins(plot: :unit_type).where(unit_types: { id: unit_type.id })
          }

    class << self
      # Look for a Lot matching the supplied Plot
      def lots(program)
        retries = 0

        begin
          response = HTTParty.get("#{program.developer.api}programs/#{program.id}",
                                  headers:
                                    {
                                      "Content-Type" => "application/json",
                                      "Accept" => "application/json",
                                      "Authorization" => "Bearer #{program.developer.token}"
                                    },
                                  timeout: 10)
          if response.code == 200
            lots = response.parsed_response["lots"]
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
          Unlatch::Log.add(program, "UNLATCH: #{__method__} Uplatch is currently unavaliable. Please try again later")
        rescue => e
          Unlatch::Log.add(program, "UNLATCH: #{__method__} Failed to retrieve Lots - #{e.message}")
        end

        lots
      end

      # Find the associated Unlatch Program,and if found, create a child Lot
      def add(plot)
        lot = lots(plot&.program)&.select { |l| l["lotNumber"].casecmp(plot.number).zero? }
        return unless lot&.count == 1

        lot = Unlatch::Lot.create(id: lot[0]["lotId"],
                                  plot_id: plot.id,
                                  program_id: plot.program.id)
        lot.resync_containers
      end
    end

    def resync_containers
      plot.phase.sync_docs_with_unlatch
      plot.unit_type.sync_docs_with_unlatch
    end
  end
  # rubocop:enable Style/RaiseArgs, Metrics/LineLength, Style/RescueStandardError
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
