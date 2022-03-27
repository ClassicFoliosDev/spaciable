# frozen_string_literal: true

module ExpiryEnum
  extend ActiveSupport::Concern

  included do
    enum expiry: %i[
      never
      one_year
      two_years
    ]
  end
end
