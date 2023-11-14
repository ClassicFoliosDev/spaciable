# frozen_string_literal: true

module ResidentInvitationService
  module_function

  def call(plot_residency, from_user, invited_by_name, plot_resident = nil)
    return unless plot_residency

    @plot = plot_residency.plot

    if plot_residency.invitation_accepted_at.nil?
      new_resident(plot_residency, from_user, invited_by_name, plot_resident)
    else
      existing_resident(plot_residency, invited_by_name)
    end
  end

  def new_resident(plot_residency, from_user, invited_by_name, plot_resident)
    resident = plot_resident || plot_residency.resident
    # Delete any reminders hanging around from a previous invitation
    JobManagementService.call(resident.id)

    resident.invitation_plot = plot_residency.plot
    resident.invite!(from_user, bcc: ENV["BCC_MAIL"])

    send_reminders(plot_residency, invited_by_name)
  end

  def send_reminders(plot_residency, invited_by_name)
    # If the resident has had a previous invitation with a token, that token
    # will be invalidated by this action: since they haven't accepted it,
    # we're assuming that they will have lost those emails: but we should
    # have stopped reminders
    token = plot_residency.resident.raw_invitation_token

    subject = I18n.t(".reminder_title", ordinal: "First")
    InvitationReminderJob.set(wait: 1.week)
                         .perform_later(plot_residency, subject, token, invited_by_name)
    subject = I18n.t(".reminder_title", ordinal: "Second")
    InvitationReminderJob.set(wait: 2.weeks)
                         .perform_later(plot_residency, subject, token, invited_by_name)
    subject = I18n.t(".last_reminder_title", ordinal: "Third")
    InvitationReminderJob.set(wait: 3.weeks)
                         .perform_later(plot_residency, subject, token, invited_by_name)
  end

  def existing_resident(plot_residency, invited_by_name)
    NewPlotJob.perform_later(plot_residency, I18n.t(".new_plot_title"), invited_by_name)
  end
end
