# frozen_string_literal: true
class Developer < ApplicationRecord
  acts_as_paranoid

  has_many :divisions, dependent: :destroy
  has_many :developments, dependent: :destroy

  has_many :documents, dependent: :destroy
  has_many :finishes, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :plots, dependent: :destroy
  has_many :phases, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy

  validates :company_name, presence: true, uniqueness: true

  delegate :to_s, to: :company_name

  paginates_per 10
end
