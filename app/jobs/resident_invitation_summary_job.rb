# frozen_string_literal: true

class ResidentInvitationSummaryJob < ApplicationJob
  queue_as :mailer

  def perform
    # Run the report inside a lock.  Lock only allows one job with
    # the same name to run at once.  ResidentInvitationSummaryJob is
    # initiated from a cron job and can be started from 1 or both
    # balancered servers simultaneously. Only 1 must be allowed to complete
    Lock.run :activation_report do
      users = User.where.not(invitation_accepted_at: nil)
                  .where(receive_invitation_emails: true)
                  .where.not(permission_level_id: nil)
      users.each do |user|
        build_report(user, user.permission_level)

        user.grants.each do |grant|
          build_report(user, grant.permission_level)
        end
      end
    end
  end

  def build_report(user, permission_level)
    return unless permission_level

    residencies = PlotResidency.where(plot_id: permission_level.plots,
                                      created_at: ((Time.zone.now - 7.days)..Time.zone.now))

    return unless residencies.size.positive?
    InvitationSummaryMailer.resident_summary(user, permission_level,
                                             residencies.to_a).deliver_later
  end
end
