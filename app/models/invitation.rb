# frozen_string_literal: true

class Invitation
  def self.resident_invitation_summary
    ResidentInvitationSummaryJob.perform_later
  end
end
