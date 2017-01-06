# frozen_string_literal: true
class FinishCategoriesType < ApplicationRecord
  belongs_to :finish_category
  belongs_to :finish_type
end
