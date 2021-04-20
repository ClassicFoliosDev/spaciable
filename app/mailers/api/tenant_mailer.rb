# frozen_string_literal: true

module Api
  class TenantMailer < ApplicationMailer
    add_template_helper(PlotRouteHelper)

    def invite(tenant, subject, token)
      return unless tenant

      @resource = tenant
      @token = token
      mail to: tenant.email, subject: subject
    end
  end
end
