# frozen_string_literal: true

module MobileSignalEnum
  extend ActiveSupport::Concern

  included do
    enum mobile_signal:
    %i[
      good
      fair
      restricted
      no_mobile_signal
    ]
  end
end
