# frozen_string_literal: true

module PackageEnum
  extend ActiveSupport::Concern

  included do
    enum package: %i[
      free
      essentials
      professional
      legacy
    ]
  end
end
