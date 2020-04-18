# frozen_string_literal: true

module ActionTypeEnum
  extend ActiveSupport::Concern

  included do
    enum action_type: %i[
      action
      feature
    ]
  end
end
