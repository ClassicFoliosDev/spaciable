# frozen_string_literal: true

module PackageEnum
  extend ActiveSupport::Concern

  included do
    enum package: %i[
      free
      essentials
      elite
      legacy
    ]
  end
end
