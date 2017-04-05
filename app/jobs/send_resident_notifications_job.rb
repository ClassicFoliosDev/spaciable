# frozen_string_literal: true
class SendResidentNotificationsJob < ActiveJob::Base
  queue_as :mailer

  def perform(resident_ids, notification)
    Resident.where(id: resident_ids).each do |resident|
      resident.notifications << notification
      ResidentNotificationMailer.notify(resident, notification).deliver_now
    end
  end
end
