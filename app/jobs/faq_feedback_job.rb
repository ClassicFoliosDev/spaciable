# frozen_string_literal: true

class FaqFeedbackJob < ApplicationJob
  queue_as :mailer

  def perform(question)
    ApplicationMailer.faq_feedback(question).deliver_now
  end
end
