# frozen_string_literal: true
module ResidentInvitationService
  module_function

  def call(resident, from_user)
    resident.invite!(from_user)
    token = resident.raw_invitation_token

    subject = I18n.t(".reminder_title", ordinal: "First")
    InvitationReminderJob.set(wait: 1.week).perform_later(resident, subject, token)
    subject = I18n.t(".reminder_title", ordinal: "Second")
    InvitationReminderJob.set(wait: 2.weeks).perform_later(resident, subject, token)
    subject = I18n.t(".last_reminder_title", ordinal: "Third")
    InvitationReminderJob.set(wait: 3.weeks).perform_later(resident, subject, token)
  end
end
