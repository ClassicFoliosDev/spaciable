# frozen_string_literal: true

module CalloutTypeEnum
  extend ActiveSupport::Concern

  included do
    enum callout_type: %i[
      action
      feature
    ]
  end
end
