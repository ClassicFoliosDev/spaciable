# frozen_string_literal: true

module ResidentInvitationService
  module_function

  def call(plot_residency, from_user)
    return unless plot_residency

    @plot = plot_residency.plot
    plot_residency.resident.invite!(from_user)
    token = plot_residency.resident.raw_invitation_token

    subject = I18n.t(".reminder_title", ordinal: "First")
    InvitationReminderJob.set(wait: 1.week).perform_later(plot_residency, subject, token)
    subject = I18n.t(".reminder_title", ordinal: "Second")
    InvitationReminderJob.set(wait: 2.weeks).perform_later(plot_residency, subject, token)
    subject = I18n.t(".last_reminder_title", ordinal: "Third")
    InvitationReminderJob.set(wait: 3.weeks).perform_later(plot_residency, subject, token)
  end
end
