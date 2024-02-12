# frozen_string_literal: true

class Package
  class << self
    # Calculate and send the invoices
    def invoice_developers
      Lock.run :package_invoice do
        Developer.on_package.each do |developer|
          next if developer.is_demo

          invoice(developer.id)
        end
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Style/RescueStandardError
    def invoice(developer_id, created_at = Time.zone.now.midnight)
      developer = Developer.find(developer_id)

      # Invoice by development
      developer.all_developments.each do |development|
        [Phase.packages[:free],
         Phase.packages[:essentials],
         Phase.packages[:elite]].each do |p|
          development.phases.where(package: p).find_each do |phase|
            package_plots = Plot.billable(phase)
            ff_plots = if %w[standard full_works].include?(phase.maintenance_account_type)
                         Plot.billable(phase, kind: :ff).count
                       end
            if package_plots.count.positive? || ff_plots
              Invoice.create(created_at: created_at,
                             phase_id: phase.id,
                             package: p,
                             cpp: CPP.find_by(package: p)&.value,
                             plots: package_plots.count,
                             ff_plots: ff_plots)
            end
          end
        end
      end

      sleep(2.minutes)
    rescue => e
      Rails.logger.debug("Failed creating #{developer.company_name} invoice - #{e.message}")
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Style/RescueStandardError
  end
end
