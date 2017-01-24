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
  has_many :residents, through: :plots
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  validates :company_name, presence: true, uniqueness: true

  delegate :to_s, to: :company_name

  paginates_per 10
end
