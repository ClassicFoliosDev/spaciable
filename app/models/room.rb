# frozen_string_literal: true
class Room < ApplicationRecord
  belongs_to :unit_type
  alias parent unit_type
  include InheritParentPermissionIds

  belongs_to :development, optional: false
  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_many :finishes, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true

  def to_s
    name
  end
end
