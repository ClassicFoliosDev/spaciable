# frozen_string_literal: true
class Notification < ApplicationRecord
  include PolymorphicPermissionable
  include PolymorphicPermissionable::ByResources
  permissionable_field :send_to

  belongs_to :author, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :send_to, polymorphic: true

  has_many :resident_notifications
  has_many :residents, through: :resident_notifications

  validates :subject, :message, :sender, presence: true
  validate :recipients_selected
  validate :send_to_conflicts

  def send_to_conflicts
    return unless send_to_all? && send_to_id.present?

    errors.add(:send_to_all, :conflicts)
  end

  def recipients_selected
    return if send_to_all? || send_to.present?

    errors.add(:send_to, :select)
  end

  def send_to
    return SendToAll.new(notification: self) if send_to_all?
    super
  end

  def send_to_all?
    return false if sender && !sender.cf_admin?
    super
  end

  def with_sender(user)
    self.sender = user
    self
  end

  delegate :role, to: :sender
  delegate :to_s, to: :subject
  delegate :to_str, to: :subject
end
