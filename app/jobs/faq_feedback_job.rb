# frozen_string_literal: true

class FaqFeedbackJob < ApplicationJob
  queue_as :mailer

  def perform(data)
    ApplicationMailer.faq_feedback(data).deliver_now
  end
end
