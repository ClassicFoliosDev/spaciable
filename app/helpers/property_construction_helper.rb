# frozen_string_literal: true

module PropertyConstructionHelper
  def property_construction_collection
    MaterialInfo.property_constructions.map do |(construction, _int)|
      [t_property_construction(construction), construction]
    end
  end

  def t_property_construction(construction)
    t(construction, scope: property_construction_label_scope)
  end

  private

  def property_construction_label_scope
    "activerecord.attributes.material_info.property_construction_labels"
  end
end