# frozen_string_literal: true

module RoomEnum
  extend ActiveSupport::Concern

  included do
    enum icon_name: %i[
      bedroom
      bathroom
      kitchen
      living_room
      dining_room
      study
      exterior
      garage
      cloakroom
      heating
      internal_finishes
      stairway
      utility
    ]
  end
end
