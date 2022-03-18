# frozen_string_literal: true

class Spotlight < ApplicationRecord
  belongs_to :development
  has_many :custom_tiles
end
