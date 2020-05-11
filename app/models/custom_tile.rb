# frozen_string_literal: true

class CustomTile < ApplicationRecord
  belongs_to :development, optional: true

  enum category: %i[
    feature
    document
    link
  ]

  enum feature: %i[
    area_guide
    home_designer
    referrals
    services
    perks
    issues
    snagging
  ]

  enum guide: %i[
    reservation
    completion
  ]

end