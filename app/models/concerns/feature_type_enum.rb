# frozen_string_literal: true

module FeatureTypeEnum
  extend ActiveSupport::Concern

  included do
    enum feature_type: %i[
      custom_url
      area_guide
      buyers_club
      calendar
      home_designer
      issues
      referrals
      services
      snagging
      tour
      conveyancing
      conveyancing_quote
      conveyancing_signin
    ]
  end
end
