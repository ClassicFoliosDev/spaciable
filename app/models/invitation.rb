# frozen_string_literal: true

class Invitation
  def self.resident_invitation_summary
    users = User.where(receive_invitation_emails: true).where.not(permission_level_id: nil)
    ResidentInvitationSummaryJob.perform_later(users)
  end
end
