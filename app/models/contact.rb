# frozen_string_literal: true

class Contact < ApplicationRecord
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache
  attr_accessor :notify

  belongs_to :developer, optional: false
  belongs_to :division, optional: true
  belongs_to :development, optional: true
  belongs_to :contactable, polymorphic: true

  alias parent contactable
  include InheritParentPermissionIds
  include InheritPolymorphicParentPermissionIds

  # ENUMS
  include TitleEnum

  enum category: %i[
    sales
    services
    customer_care
    management
    emergency
  ]

  validates :contactable_id, presence: true
  validate :email_or_phone
  validate :name_or_organisation

  def email_or_phone
    return unless email.blank? && phone.blank?
    errors.add(:base, :email_or_phone_required)
  end

  def name_or_organisation
    return if organisation.present? || first_name.present? || last_name.present?
    errors.add(:base, :name_or_organisation_required)
  end

  def to_s
    full_name = "#{first_name} #{last_name}"

    if full_name.strip.present?
      full_name
    else
      organisation
    end
  end
end
