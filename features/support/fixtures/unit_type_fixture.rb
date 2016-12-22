# frozen_string_literal: true
module UnitTypeFixture
  module_function

  def updated_unit_type_name
    "Beta"
  end

  def update_attrs
    {
      name: updated_unit_type_name
    }
  end
end
