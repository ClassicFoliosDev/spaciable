# frozen_string_literal: true
class FeedbackNotificationJob < ActiveJob::Base
  queue_as :mailer

  def perform(comments, option, email)
    ApplicationMailer.feedback(comments, option, email).deliver_now
  end
end
