# frozen_string_literal: true

class Package
  class << self
    # Calculate and send the invoices
    def invoice_developers
      Lock.run :package_invoice do
        Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

        Developer.on_package.each do |developer|
          invoice(developer.id)
        end
      end
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def invoice(developer_id)
      developer = Developer.find(developer_id)

      # create the invoice items
      developer.developments.each do |development|
        [Phase.packages[:essentials], Phase.packages[:professional]].each do |p|
          development.phases.where(package: p).find_each do |phase|
            Stripe::InvoiceItem.create(
              customer: developer.stripe_code,
              price: developer.stripe_codes.find_by(package: p).code,
              quantity: phase.plots.count,
              description: "#{development.name} #{phase.name}"
            )
          end
        end
      end

      # create the invoice
      invoice = Stripe::Invoice.create(
        customer: developer.stripe_code,
        collection_method: "send_invoice",
        days_until_due: 30
      )

      # finalise
      Stripe::Invoice.finalize_invoice(invoice[:id])

      # send
      Stripe::Invoice.send_invoice(invoice[:id])
    rescue => e
      Rails.logger.debug("Failed to create #{developer.company_name} invoice - #{e.message}")
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
