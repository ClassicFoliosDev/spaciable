# frozen_string_literal: true
class Division < ApplicationRecord
  acts_as_paranoid
  belongs_to :developer

  alias parent developer

  has_many :developments, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :faqs, as: :faqable
  has_many :phases, dependent: :destroy
  has_many :plots, dependent: :destroy
  has_many :plot_residencies, through: :plots
  has_many :residents, through: :plot_residencies
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_many :contacts, as: :contactable
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  validates :division_name, presence: true, uniqueness: { scope: :developer_id }

  delegate :to_s, to: :division_name
  delegate :api_key, to: :developer

  paginates_per 25
end
