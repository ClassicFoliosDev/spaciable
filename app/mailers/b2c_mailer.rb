# frozen_string_literal: true

class B2cMailer < ActionMailer::Base
  default from: "no-reply@isyt.com"
  layout "email"

  def register(client)
    @client = client

    mail to: client.email, subject: I18n.t("b2c_mailer.title")
  end
end
