# frozen_string_literal: true
class DeviseMailer < Devise::Mailer
  layout "email"
  default from: "no-reply@hoozzi.com"
end
