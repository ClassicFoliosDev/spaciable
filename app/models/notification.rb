# frozen_string_literal: true
class Notification < ApplicationRecord
  attr_accessor :developer_id, :division_id, :development_id, :phase_id

  belongs_to :author, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :send_to, polymorphic: true

  has_many :resident_notifications
  has_many :homeowners, through: :resident_notifications, source: :resident

  validates :subject, :message, :sender, presence: true
  validate :send_to_selection_validation

  before_validation :set_send_to_using_resource_ids

  def send_to_selection_validation
    return if send_to || !blank_permission_ids?

    errors.add(:send_to, :selection)
    errors.add(:developer_id, :blank)
  end

  def blank_permission_ids?
    [developer_id, division_id, development_id, phase_id].all?(&:blank?)
  end

  def set_send_to_using_resource_ids
    return if send_to && blank_permission_ids?
    send_to_id, send_to_type =
      if phase_id.present?
        [phase_id, "Phase"]
      elsif development_id.present?
        [development_id, "Development"]
      elsif division_id.present?
        [division_id, "Division"]
      elsif developer_id.present?
        [developer_id, "Developer"]
      end

    self.send_to_id = send_to_id
    self.send_to_type = send_to_type
  end

  def with_sender(user)
    self.sender = user
    self
  end

  def populate_permission_ids
    return unless send_to

    case send_to
    when Developer
      set_developer_id
    when Division
      set_division_id
    when Development
      set_development_id
    when Phase
      set_phase_id
    end
  end

  def set_developer_id
    self.developer_id = send_to_id
  end

  def set_division_id
    self.division_id = send_to_id
    self.developer_id = send_to.developer_id
  end

  def set_development_id
    self.development_id = send_to.id
    self.division_id = send_to.division_id
    self.developer_id = send_to.developer_id ||
                        send_to.division&.developer_id
  end

  def set_phase_id
    self.phase_id = send_to.id
    self.development_id = send_to.development_id
    self.division_id = send_to.division_id
    self.developer_id = send_to.developer_id ||
                        send_to.division&.developer_id
  end

  delegate :to_s, to: :subject
end
