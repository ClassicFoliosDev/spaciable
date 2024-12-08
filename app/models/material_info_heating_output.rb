# frozen_string_literal: true

class MaterialInfoHeatingOutput < ApplicationRecord
  belongs_to :material_info
  has_one :heating_output
end
