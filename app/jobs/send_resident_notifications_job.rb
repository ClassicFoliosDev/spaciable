# frozen_string_literal: true
class SendResidentNotificationsJob
  include SuckerPunch::Job

  def perform(resident_ids, notification)
    ActiveRecord::Base.connection_pool.with_connection do
      User.homeowner.where(id: resident_ids).each do |resident|
        resident.homeowner_notifications << notification
        ResidentNotificationMailer.notify(resident, notification).deliver_now
      end
    end
  end
end
