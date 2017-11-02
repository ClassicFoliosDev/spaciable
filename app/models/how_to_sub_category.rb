# frozen_string_literal: true

class HowToSubCategory < ApplicationRecord
  validates :name, presence: true

  has_many :how_tos

  def to_s
    name
  end
end
