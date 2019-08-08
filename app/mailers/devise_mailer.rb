# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  layout "email"
  add_template_helper(PlotRouteHelper)
  add_template_helper(AdminNameHelper)
  default from: "no-reply@spaciable.com"
end
