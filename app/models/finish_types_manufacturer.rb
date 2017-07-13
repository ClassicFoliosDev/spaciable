# frozen_string_literal: true
class FinishTypesManufacturer < ApplicationRecord
  belongs_to :finish_type
  belongs_to :finish_manufacturer
  belongs_to :manufacturer, optional: true

  validates :finish_type, uniqueness: { scope: [:finish_manufacturer, :manufacturer] }, on: :create
end
