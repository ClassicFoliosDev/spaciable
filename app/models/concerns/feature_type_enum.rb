# frozen_string_literal: true

module FeatureTypeEnum
  extend ActiveSupport::Concern

  included do
    enum feature_type: %i[
      custom_url
      area_guide
      home_designer
      referrals
      services
      buyers_club
      issues
      snagging
      tour
      calendar
    ]
  end
end
