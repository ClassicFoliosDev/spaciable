# frozen_string_literal: true

class Chart < ApplicationRecord
  belongs_to :chartable, polymorphic: true

  enum section: {
    plot_invite: 0,
    competition: 100
  }

  enum criteria: %i[
    invited
    not_invited
    activated
  ]

  scope :plots,
        lambda { |developer, division, development, phase, criteria|
          plots = Plot.where.not(completion_release_date: nil)
                      .or(Plot.where.not(reservation_release_date: nil))
          plots = plots.joins(:phase).where.not(phases: { business: Phase.businesses[:mhf] })
          plots = plots.where(developer_id: developer) unless developer.zero?
          plots = plots.where(division_id: division) unless division.zero?
          plots = plots.where(development_id: development) unless development.zero?
          plots = plots.where(phase_id: phase) unless phase.zero?

          case criteria
          when :invited
            plots = plots.joins(:residents)
          when :activated
            plots = plots.joins(:residents).where.not(residents: { invitation_accepted_at: nil })
          when :not_invited
            plots = plots.left_outer_joins(:residents).where(residents: { id: nil })
          end
          plots.distinct
        }
end
