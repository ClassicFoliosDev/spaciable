# frozen_string_literal: true

# rubocop:disable ClassLength
class Notification < ApplicationRecord
  attr_accessor :range_from, :range_to, :list
  attr_accessor :read_at
  attr_accessor :developer_id, :division_id, :development_id, :phase_id

  belongs_to :author, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :send_to, polymorphic: true

  has_many :resident_notifications
  has_many :residents, through: :resident_notifications

  validates :subject, :message, :sender, presence: true
  validate :recipients_selected
  validate :send_to_conflicts

  enum send_to_role: %i[
    tenant
    homeowner
    both
  ]

  enum plot_filter: %i[
    all_plots
    completed_plots
    reservation_plots
  ]

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
    if plot_numbers.empty?
      full_sent_to
    else
      to_count = plot_numbers.count > 1 ? :plural : :singular
      plot_title = Plot.model_name.send(to_count).titleize
      parent = full_sent_to

      "#{parent} (#{plot_title} #{plot_numbers.to_sentence})"
    end
  end

  def sent_from
    sender = User.find_by(id: sender_id)
    if sender.present?
      "#{sender.email} (#{sender.permission_level_name})"
    else
      "User Deleted"
    end
  end

  def permission_level_name
    if sender.present?
      permission_level || "Spaciable Admin"
    else
      "User Deleted"
    end
  end

  def sent_to_role
    if send_to_role == "homeowner"
      I18n.t("admin.notifications.form.homeowner")
    elsif send_to_role == "tenant"
      I18n.t("admin.notifications.form.tenant")
    else
      I18n.t("admin.notifications.form.both")
    end
  end

  # rubocop:disable all
  def full_sent_to
    sent = send_to.to_s
    type = send_to_type
    case type
    when "Development"
      development = Development.find_by(id: send_to_id)
      if development.present?
        parent = development&.division ? development.division : development&.developer
        return "#{sent} (#{parent})"
      else
        return "(Removed)"
      end
    when "Phase"
      phase = Phase.find_by(id: send_to_id)
      if phase.present?
        development = phase.development
        division = phase.division
        if division.present?
          "#{sent} (#{development}, #{division})"
        else
          "#{sent} (#{development})"
        end
      else
        return "(Removed)"
      end
    else
      return sent.present? ? sent : "(Removed)"
    end
  end
  # rubocop:enable all

  # get the valid plots associated with the notification
  def plot_ids
    plots = if send_to_type == "Plot"
              [Plot.find(send_to_id)]
            else
              send_to.plots
            end

    plots.reject(&:expired?).pluck(:id) unless sender.cf_admin?
    plots.pluck(:id)
  end

  delegate :role, to: :sender, allow_nil: true
  delegate :job_title, to: :sender, allow_nil: true
  delegate :first_name, to: :sender, allow_nil: true
  delegate :last_name, to: :sender, allow_nil: true
  delegate :picture, to: :sender, allow_nil: true
  delegate :to_s, to: :subject
  delegate :to_str, to: :subject
  delegate :permission_level, to: :sender, allow_nil: true
end
# rubocop:enable ClassLength
