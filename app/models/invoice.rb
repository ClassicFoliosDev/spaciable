# frozen_string_literal: true

# rubocop:disable LineLength
class Invoice < ApplicationRecord
  include PackageEnum
  belongs_to :phase

  scope :by_phase,
        lambda { |start, finish, developer, division, development|
          # Phase left outer join with Divisions
          phase = Phase.arel_table
          div = Division.arel_table
          join_on = phase.create_on(phase[:division_id].eq(div[:id]))
          div_join = phase.create_join(div, join_on, Arel::Nodes::OuterJoin)

          invoices = Invoice.joins(phase: :developer)
                            .joins(div_join)
                            .joins(phase: :development)
                            .where(phases: { package: [Phase.packages[:free],
                                                       Phase.packages[:essentials],
                                                       Phase.packages[:elite]] })
                            .where("invoices.created_at >= ?", start)
                            .where("invoices.created_at <= ?", finish)

          invoices = invoices.where(phases: { developer_id: developer }) if developer.present?
          invoices = invoices.where(phases: { division_id: division }) if division.present?
          invoices = invoices.where(phases: { development_id: development }) if development.present?
          invoices.order(:created_at,
                         "developers.company_name",
                         "divisions.division_name",
                         "developments.name",
                         "phases.name")
        }
end
# rubocop:enable LineLength
