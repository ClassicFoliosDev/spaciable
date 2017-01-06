# frozen_string_literal: true
class FinishTypesManufacturer < ApplicationRecord
  belongs_to :finish_type
  belongs_to :manufacturer
end
