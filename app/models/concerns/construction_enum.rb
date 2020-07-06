# frozen_string_literal: true

module ConstructionEnum
  extend ActiveSupport::Concern

  included do
    enum construction:
    %i[
      residential
      commercial
    ]
  end
end
