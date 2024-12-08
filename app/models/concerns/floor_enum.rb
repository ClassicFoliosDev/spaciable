# frozen_string_literal: true

module FloorEnum
  extend ActiveSupport::Concern

  included do
    enum floor: 
    %i[
      ground
      first_
      second_
      third_
      forth_
      fifth_
      sixth_
      seventh_
      eigth_
      ninth_
      tenth_
      eleventh_
      twelth_
      thirteenth_
      fourteenth_
      fifteenth_
      sixteenth_
      seventeenth_
      eighteenth_
      nineteenth_
    ]
  end
end
