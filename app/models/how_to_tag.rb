# frozen_string_literal: true
class HowToTag < ApplicationRecord
  self.table_name = "how_tos_tags"

  belongs_to :how_to
  belongs_to :tag

  validates :tag, uniqueness: { scope: :how_to }, on: :create
  validates :tag, presence: true
  validates :how_to, presence: true
end
