# frozen_string_literal: true

class Package
  class << self
    # Calculate and send the invoices
    def invoice_developers
      Lock.run :package_invoice do
        Developer.on_package.each do |developer|
          invoice(developer.id)
        end
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def invoice(developer_id, created_at = Time.zone.now.midnight)
      developer = Developer.find(developer_id)

      # Invoice by development
      developer.all_developments.each do |development|
        [Phase.packages[:essentials], Phase.packages[:professional]].each do |p|
          development.phases.where(package: p).find_each do |phase|
            plots_billable = Plot.billable(phase)
            if plots_billable.rows.count.positive?
              Invoice.create(created_at: created_at,
                             phase_id: phase.id,
                             package: p,
                             plots: plots_billable.rows.count)
            end
          end
        end
      end
    rescue => e
      Rails.logger.debug("Failed creating #{developer.company_name} invoice - #{e.message}")
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
