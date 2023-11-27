# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
class HowToSubCategory < ApplicationRecord
  validates :name, presence: true

  has_many :how_tos

  def to_s
    name
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent
