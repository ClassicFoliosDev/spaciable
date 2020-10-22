# frozen_string_literal: true

module DivisionDevelopmentFixture
  module_function

  def updated_development_name
    "Harbourside Development"
  end

  def second_development_name
    "Forest View"
  end

  def update_snagging
    {
      snag_duration: "56",
      snag_name: "Fixy Breaky"
    }
  end

  def development_address_update_attrs
    {
      city: "Wadeland",
      county: "Gibsonton",
    }
  end
end
