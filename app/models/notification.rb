# frozen_string_literal: true
class Notification < ApplicationRecord
  include PolymorphicPermissionable
  include PolymorphicPermissionable::ByResources
  permissionable_field :send_to

  belongs_to :author, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :send_to, polymorphic: true

  has_many :resident_notifications
  has_many :homeowners, through: :resident_notifications, source: :resident

  validates :subject, :message, :sender, presence: true

  def with_sender(user)
    self.sender = user
    self
  end

  delegate :role, to: :sender
  delegate :to_s, to: :subject
  delegate :to_str, to: :subject
end
