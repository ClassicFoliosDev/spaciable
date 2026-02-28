# frozen_string_literal: true

module PropertyTypeEnum
  extend ActiveSupport::Concern

  included do
    enum property_type:
    %i[
      detached
      semi
      terraced
      end_terrace
      mid_terrace
      bungalow
      apartment
      duplex
      maisonette
      studio
      coach_house
    ]
  end
end
