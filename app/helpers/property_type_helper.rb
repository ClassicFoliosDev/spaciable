# frozen_string_literal: true

module PropertyTypeHelper
  def property_type_collection
    MaterialInfo.property_types.map do |(property_type, _int)|
      [t_property_type(property_type), property_type]
    end
  end

  def t_property_type(property_type)
    t(property_type, scope: property_type_label_scope)
  end

  private

  def property_type_label_scope
    "activerecord.attributes.material_info.property_type_labels"
  end
end
