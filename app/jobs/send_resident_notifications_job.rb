# frozen_string_literal: true
class SendResidentNotificationsJob
  include SuckerPunch::Job

  def perform(resident_ids, notification)
    ActiveRecord::Base.connection_pool.with_connection do
      Resident.where(id: resident_ids).each do |resident|
        resident.notifications << notification
        ResidentNotificationMailer.notify(resident, notification).deliver_now
      end
    end
  end
end
