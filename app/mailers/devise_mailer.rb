# frozen_string_literal: true
class DeviseMailer < Devise::Mailer
  layout "email"
  add_template_helper(ResidentRouteHelper)
  default from: "no-reply@hoozzi.com"
end
