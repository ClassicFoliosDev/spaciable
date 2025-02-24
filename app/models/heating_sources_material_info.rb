# frozen_string_literal: true

class HeatingSourcesMaterialInfo < ApplicationRecord
  belongs_to :material_info
  belongs_to :heating_source
end
