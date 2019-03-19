# frozen_string_literal: true

class AdminNotification < ApplicationRecord
  attr_accessor :read_at

  belongs_to :author, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :send_to, polymorphic: true

  has_many :admin_notifications
  has_many :users, through: :admin_notifications

  validates :subject, :message, :sender, presence: true

  def with_sender(user)
    self.sender = user
    self
  end

  delegate :role, to: :sender, allow_nil: true
  delegate :first_name, to: :sender, allow_nil: true
  delegate :last_name, to: :sender, allow_nil: true

  delegate :to_s, to: :subject
  delegate :to_str, to: :subject
end
