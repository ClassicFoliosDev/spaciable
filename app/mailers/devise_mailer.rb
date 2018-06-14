# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  layout "email"
  add_template_helper(PlotRouteHelper)
  default from: "no-reply@isyt.com"
end
