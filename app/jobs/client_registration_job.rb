# frozen_string_literal: true

class ClientRegistrationJob < ApplicationJob
  queue_as :b2c_mailer

  def perform(client)
    B2cMailer.register(client).deliver_now
  end
end
