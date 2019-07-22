# frozen_string_literal: true

class FeedbackNotificationJob < ApplicationJob
  queue_as :mailer

  def perform(comments, option, email, details)
    ApplicationMailer.feedback(comments, option, email, details).deliver_now
  end
end
