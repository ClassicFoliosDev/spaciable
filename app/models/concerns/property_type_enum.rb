# frozen_string_literal: true

module PropertyTypeEnum
  extend ActiveSupport::Concern

  included do
    enum property_type:
    %i[
      detached
      semi
      terraced
      bungalow
      apartment
      duplex
      maisonette
      studio
    ]
  end
end
