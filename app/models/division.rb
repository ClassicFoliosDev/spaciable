# frozen_string_literal: true
class Division < ApplicationRecord
  belongs_to :developer

  has_many :developments, through: :developer
  has_many :documents, dependent: :destroy
  has_many :finishes, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :plots, dependent: :destroy
  has_many :phases, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy

  validates :division_name, presence: true, uniqueness: true

  def to_s
    division_name
  end
end
