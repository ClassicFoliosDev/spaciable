# frozen_string_literal: true

class MaterialInfoHeatingSource < ApplicationRecord
  belongs_to :material_info
  has_one :heating_source
end
