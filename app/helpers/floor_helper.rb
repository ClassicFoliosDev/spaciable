# frozen_string_literal: true

module FloorHelper
  def floor_collection
    MaterialInfo.floors.map do |(floor, _int)|
      [t_floor(floor), floor]
    end
  end

  def t_floor(floor)
    t(floor, scope: floor_label_scope)
  end

  private

  def floor_label_scope
    "activerecord.attributes.material_info.floor_labels"
  end
end
