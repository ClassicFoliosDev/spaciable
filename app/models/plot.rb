# frozen_string_literal: true
class Plot < ApplicationRecord
  acts_as_paranoid

  belongs_to :phase, optional: true
  belongs_to :development, optional: false
  def parent
    phase || development
  end
  include InheritParentPermissionIds

  belongs_to :unit_type, optional: true
  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_many :unit_types, through: :development
  has_many :plot_residents
  has_many :residents, through: :plot_residents
  has_many :rooms, through: :unit_type
  has_many :finishes, through: :rooms
  has_many :documents, as: :documentable
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  validates :number, presence: true

  def resident
    residents.last
  end

  # `1.0` becomes `1`
  # `1.1` stays as `1.1`
  def number
    return self[:number] unless self[:number].to_i == self[:number]
    self[:number].to_i
  end

  def parent=(object)
    case object
    when Phase
      self.phase = object
      self.development = nil
    when Development
      self.phase = nil
      self.development = object
    end
  end

  def to_s
    if prefix.blank?
      number.to_s
    else
      "#{prefix} #{number}"
    end
  end
end
