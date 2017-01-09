# frozen_string_literal: true
class ApplianceCategoriesManufacturer < ApplicationRecord
  belongs_to :appliance_category
  belongs_to :manufacturer
end
