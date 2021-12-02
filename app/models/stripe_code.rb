# frozen_string_literal: true

# Timeline Task actions.
class StripeCode < ApplicationRecord
  include PackageEnum
  belongs_to :developer
  validates :code, :package, presence: true
end
