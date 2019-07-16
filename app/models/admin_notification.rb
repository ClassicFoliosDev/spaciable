# frozen_string_literal: true

class AdminNotification < ApplicationRecord
  attr_accessor :read_at
  attr_accessor :developer_id

  belongs_to :author, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :send_to, polymorphic: true

  has_many :admin_notifications
  has_many :users, through: :admin_notifications

  validates :subject, :message, :sender, presence: true
  validate :send_to_conflicts
  validate :recipients_selected

  def with_sender(user)
    self.sender = user
    self
  end

  delegate :role, to: :sender, allow_nil: true
  delegate :first_name, to: :sender, allow_nil: true
  delegate :last_name, to: :sender, allow_nil: true

  delegate :to_s, to: :subject
  delegate :to_str, to: :subject

  def send_to_conflicts
    return unless send_to_all? && send_to_id.present?
    errors.add(:send_to_all, :conflicts)
  end

  def recipients_selected
    return if send_to_all? || send_to.present?

    errors.add(:send_to, :select)
  end

  def sent_to
    if send_to_all
      "All"
    else
      send_to
    end
  end
end
