# frozen_string_literal: true

class HeatingOutputsMaterialInfo < ApplicationRecord
  belongs_to :material_info
  belongs_to :heating_output
end
