# frozen_string_literal: true

module RepeatEnum
  extend ActiveSupport::Concern

  included do
    enum repeat: %i[
      never
      daily
      weekly
      biweekly
      monthly
      yearly
    ]
  end
end
