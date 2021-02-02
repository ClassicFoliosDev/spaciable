# frozen_string_literal: true

module GuideEnum
  extend ActiveSupport::Concern

  included do
    enum guide: %i[
      reservation
      completion
      floor_plan
    ]
  end
end
