# frozen_string_literal: true
class SendResidentNotificationsJob < ActiveJob::Base
  queue_as :mailer

  def perform(resident_ids, notification)
    puts "========="
    puts "Send resident job"
    Resident.where(id: resident_ids).each do |resident|
      puts "-------------"
      puts resident.email

      resident.notifications << notification
      ResidentNotificationMailer.notify(resident, notification).deliver_now
    end

    puts "==========="
  end
end
