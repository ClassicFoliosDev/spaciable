# frozen_string_literal: true

class HeatingFuelsMaterialInfo < ApplicationRecord
  belongs_to :material_info
  belongs_to :heating_fuel
end
