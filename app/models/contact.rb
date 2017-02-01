# frozen_string_literal: true
class Contact < ApplicationRecord
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache
  attr_accessor :target

  belongs_to :contactable, polymorphic: true

  enum title: [
    :mr,
    :ms,
    :mrs,
    :miss,
    :dr,
    :prof,
    :other
  ]

  enum category: [
    :customer_care,
    :sales,
    :warranty_provider,
    :local_authority,
    :emergency,
    :concierge
  ]

  validates :contactable_id, presence: true
  validate :email_or_phone
  validate :name_or_organisation

  def email_or_phone
    return unless email.blank? && phone.blank?
    errors.add(:base, :email_or_phone_required)
  end

  def name_or_organisation
    return unless organisation.blank? && first_name.blank? && last_name.blank?
    errors.add(:base, :name_or_organisation_required)
  end

  def target
    case contactable_type
    when "Developer"
      self.target = [contactable, active_tab: "contacts"]
    when "Division"
      self.target = [contactable.developer, contactable, active_tab: "contacts"]
    when "Development"
      self.target = [contactable.parent, contactable, active_tab: "contacts"]
    end
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
