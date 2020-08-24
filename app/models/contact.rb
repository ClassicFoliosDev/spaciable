# frozen_string_literal: true

class Contact < ApplicationRecord
  include ContactTypeEnum

  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache
  attr_accessor :notify

  belongs_to :contactable, polymorphic: true

  alias parent contactable

  delegate :expired?, to: :parent
  delegate :partially_expired?, to: :parent

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

  scope :of_types,
        lambda { |plot, types|
          contacts = Contact.where(contact_type: types)
          contacts.where(contactable_type: "Developer", contactable_id: plot.developer.id)
                  .or(contacts.where(contactable_type: "Development",
                                     contactable_id: plot.development.id))
                  .or(contacts.where(contactable_type: "Phase",
                                     contactable_id: plot.phase.id))
                  .or(contacts.where(contactable_type: "Division",
                                     contactable_id: plot.division&.id || 0))
                  .group(:contactable_type, :id)
        }

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
