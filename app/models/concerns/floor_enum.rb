# frozen_string_literal: true

module FloorEnum
  extend ActiveSupport::Concern

  included do
    enum floor: 
    %i[
      ground, 
      first,
      second,
      third,
      forth,
      fifth,
      sixth,
      seventh,
      eigth,
      ninth,
      tenth,
      eleventh,
      twelth,
      thirteenth
      fourteenth,
      fifteenth,
      sixteenth,
      seventeenth,
      eighteenth,
      nineteenth
    ]
  end
end
