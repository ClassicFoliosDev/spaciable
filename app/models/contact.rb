# frozen_string_literal: true
class Contact < ApplicationRecord
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

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

  validate :email_or_phone

  def email_or_phone
    return unless email.blank? && phone.blank?
    errors.add(:base, :email_or_phone_required)
  end

  def to_s
    full_name = "#{first_name} #{last_name}"

    if full_name.strip.present?
      full_name
    elsif email.present?
      email
    else
      phone
    end
  end
end
