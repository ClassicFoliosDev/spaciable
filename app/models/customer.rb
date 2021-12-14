# frozen_string_literal: true

# Timeline Task actions.
class Customer < ApplicationRecord
  include PackageEnum
  belongs_to :customerable, polymorphic: true
  validate :check_code

  has_many :package_prices, dependent: :destroy
  accepts_nested_attributes_for :package_prices, allow_destroy: true

  def check_code
    return if code.present?
    errors.add(:code, "Please add the associated customer code from Stripe")
  end

  def build
    return unless package_prices.empty?
    package_prices.build(package: :essentials)
    package_prices.build(package: :professional)
  end
end
