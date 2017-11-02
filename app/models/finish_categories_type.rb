# frozen_string_literal: true

class FinishCategoriesType < ApplicationRecord
  belongs_to :finish_category
  belongs_to :finish_type

  validates :finish_category, uniqueness: { scope: :finish_type }, on: :create
end
