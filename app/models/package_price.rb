# frozen_string_literal: true

# Timeline Task actions.
class PackagePrice < ApplicationRecord
  include PackageEnum
  belongs_to :customer
  validate :check_price_code

  def check_price_code
    return if code.present?
    errors.add(:code, "Please add the associated product price code from Stripe")
  end
end
