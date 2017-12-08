# frozen_string_literal: true

class PlotResidency < ApplicationRecord
  acts_as_paranoid

  belongs_to :plot, optional: false
  belongs_to :resident, optional: false, autosave: true

  validate :email_updated, on: :update
  validates_associated :resident
  validates :resident, uniqueness: { scope: :plot }

  before_validation :set_resident
  before_validation :assign_resident_attributes
  before_validation :allow_resident_to_be_passwordless

  def allow_resident_to_be_passwordless
    resident.extend(User::NoPasswordRequired)
  end

  def email_updated
    return if email == Resident.find(resident.id).email

    errors.add(:email, :change_email)
  end

  delegate :to_s, :title, :first_name, :last_name, :email, :phone_number, to: :resident
  delegate :invited_by, to: :resident

  attr_writer :title, :first_name, :last_name, :email, :phone_number

  private

  def set_resident
    return if resident_id?

    self.resident = Resident.find_by(email: @email) || build_resident
  end

  def assign_resident_attributes
    attrs = %i[title first_name last_name email phone_number]
            .each_with_object({}) do |attr, acc|
      value = instance_variable_get("@#{attr}")
      acc[attr] = value if value.present?
    end

    resident.assign_attributes(attrs)
  end
end
