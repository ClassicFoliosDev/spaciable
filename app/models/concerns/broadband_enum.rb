# frozen_string_literal: true

module BroadbandEnum
  extend ActiveSupport::Concern

  included do
    enum broadband: %i[
      not_applicable
      adsl_copper
      cable
      fttc
      fttp
    ]
  end
end
