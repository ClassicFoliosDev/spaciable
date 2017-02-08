# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@hoozzi.com"
  layout "email"
end
