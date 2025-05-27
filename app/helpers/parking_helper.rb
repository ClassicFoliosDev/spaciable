# frozen_string_literal: true

module ParkingHelper
  def parking_collection
    MaterialInfo.parkings.map do |(supply, _int)|
      [t_parking(supply), supply]
    end
  end

  def t_parking(supply)
    t(supply, scope: parking_label_scope)
  end

  private

  def parking_label_scope
    "activerecord.attributes.material_info.parking_labels"
  end
end
