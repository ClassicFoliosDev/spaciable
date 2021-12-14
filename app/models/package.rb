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

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def invoice(developer_id)
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      developer = Developer.find(developer_id)

      # Invoice by development
      developer.all_developments.each do |development|
        charge = false

        [Phase.packages[:essentials], Phase.packages[:professional]].each do |p|
          development.phases.where(package: p).find_each do |phase|
            plots_billable = Plot.billable(phase)
            if plots_billable.rows.count.positive?
              charge = true
              Stripe::InvoiceItem.create(
                customer: development.customer_details.code,
                price: development.customer_details.package_prices.find_by(package: p).code,
                quantity: plots_billable.rows.count,
                description: "#{development.name} #{phase.name}"
              )
            end
          end
        end

        next unless charge

        # create the invoice
        invoice = Stripe::Invoice.create(
          customer: development.customer_details.code,
          collection_method: "send_invoice",
          days_until_due: 30
        )

        # finalise
        Stripe::Invoice.finalize_invoice(invoice[:id])

        # send
        Stripe::Invoice.send_invoice(invoice[:id])
      end
    rescue => e
      Rails.logger.debug("Failed creating #{developer.company_name} invoice - #{e.message}")
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
