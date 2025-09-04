# frozen_string_literal: true

module ParkingEnum
  extend ActiveSupport::Concern

  included do
    enum parking:
    %i[
      parking_unassigned
      no_parking
      garage
      drive
      allocated_car_park
      unallocated_car_park
      street_parking_permit
      street_parking_no_permit
    ]
  end
end
