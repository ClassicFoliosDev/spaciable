# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
class Tag < ApplicationRecord
  delegate :to_s, to: :name

  has_many :how_to_tags
  has_many :how_tos, through: :how_to_tags

  delegate :to_s, to: :name
end
# rubocop:enable Rails/HasManyOrHasOneDependent
