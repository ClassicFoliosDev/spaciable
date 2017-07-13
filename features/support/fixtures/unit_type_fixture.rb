# frozen_string_literal: true
module UnitTypeFixture
  module_function

  def updated_unit_type_name
    "Beta"
  end

  def update_attrs
    {
      name: updated_unit_type_name,
      external_link: external_url
    }
  end

  def external_url
    "https://my.matterport.com/show/?m=dummy"
  end
end
