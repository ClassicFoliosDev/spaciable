# frozen_string_literal: true

module DeveloperDevelopmentFixture
  module_function

  def updated_development_name
    "Harbourside Development"
  end

  def second_development_name
    "Meadow View"
  end

  def development_address_update_attrs
    {
      city: "Wadeland",
      county: "Gibsonton",
    }
  end
end
