# frozen_string_literal: true

class FeedbackNotificationJob < ApplicationJob
  queue_as :mailer

  def perform(comments, option, email)
    ApplicationMailer.feedback(comments, option, email).deliver_now
  end
end
