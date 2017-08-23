# frozen_string_literal: true
class Notification < ApplicationRecord
  include PolymorphicPermissionable
  include PolymorphicPermissionable::ByResources
  permissionable_field :send_to

  attr_accessor :range_from, :range_to, :list
  attr_accessor :read_at

  belongs_to :author, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :send_to, polymorphic: true

  has_many :resident_notifications
  has_many :residents, through: :resident_notifications

  validates :subject, :message, :sender, presence: true
  validate :recipients_selected
  validate :send_to_conflicts

  def picture_name
    return "user-circle-o.jpg" if picture.blank?
    picture
  end

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

  def plot_numbers
    self[:plot_numbers] || []
  end

  def sent_to
    return send_to.to_s if plot_numbers.empty?
    to_count = plot_numbers.count > 1 ? :plural : :singular
    plot_title = Plot.model_name.send(to_count).titleize

    "#{send_to} (#{plot_title} #{plot_numbers.to_sentence})"
  end

  delegate :role, to: :sender, allow_nil: true
  delegate :job_title, to: :sender, allow_nil: true
  delegate :first_name, to: :sender, allow_nil: true
  delegate :last_name, to: :sender, allow_nil: true
  delegate :picture, to: :sender, allow_nil: true
  delegate :to_s, to: :subject
  delegate :to_str, to: :subject
end
