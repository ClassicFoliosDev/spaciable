# frozen_string_literal: true

module UnitTypesHelper
  def build_types_collection
    UnitType.build_types.map do |(build_type_name, _build_type_int)|
      [t(build_type_name, scope: i18n_scope), build_type_name]
    end
  end

  private

  def i18n_scope
    "activerecord.attributes.unit_type.build_types"
  end
end
