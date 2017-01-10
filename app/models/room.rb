# frozen_string_literal: true
class Room < ApplicationRecord
  acts_as_paranoid

  belongs_to :unit_type, optional: false
  belongs_to :development, optional: true
  belongs_to :division, optional: true
  belongs_to :developer, optional: false

  alias parent unit_type
  include InheritParentPermissionIds

  has_many :finishes, dependent: :destroy
  accepts_nested_attributes_for :finishes, reject_if: :all_blank, allow_destroy: true

  has_many :documents, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true

  def build_finishes
    finishes.build if finishes.none?
  end

  def to_s
    name
  end
end
