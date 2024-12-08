# frozen_string_literal: true

module TenureEnum
  extend ActiveSupport::Concern

  included do
    enum tenure: %i[
      unassigned
      freehold
      leasehold
      shared_ownership
      rented
      commonhold
  ]
  end
end
