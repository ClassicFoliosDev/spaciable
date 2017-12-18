# frozen_string_literal: true

module ResidentInvitationService
  module_function

  def call(plot_residency, from_user)
    return unless plot_residency

    @plot = plot_residency.plot

    if plot_residency.invitation_accepted_at.nil?
      new_resident(plot_residency, from_user)
    else
      existing_resident(plot_residency)
    end
  end

  private

  module_function

  def new_resident(plot_residency, from_user)
    resident = plot_residency.resident
    # Delete any reminders hanging around from a previous invitation
    JobManagementService.call(resident.id)

    resident.invitation_plot = plot_residency.plot
    resident.invite!(from_user)
    # If the resident has had a previous invitation with a token, that token
    # will be invalidated by this action: since they haven't accepted it,
    # we're assuming that they will have lost those emails: but we should
    # have stopped reminders
    token = plot_residency.resident.raw_invitation_token

    subject = I18n.t(".reminder_title", ordinal: "First")
    InvitationReminderJob.set(wait: 1.week).perform_later(plot_residency, subject, token)
    subject = I18n.t(".reminder_title", ordinal: "Second")
    InvitationReminderJob.set(wait: 2.weeks).perform_later(plot_residency, subject, token)
    subject = I18n.t(".last_reminder_title", ordinal: "Third")
    InvitationReminderJob.set(wait: 3.weeks).perform_later(plot_residency, subject, token)
  end

  def existing_resident(plot_residency)
    NewPlotJob.perform_later(plot_residency, I18n.t(".new_plot_title"))
  end
end
