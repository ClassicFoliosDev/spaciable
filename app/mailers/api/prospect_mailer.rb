# frozen_string_literal: true

module Api
  class ProspectMailer < ApplicationMailer
    add_template_helper(PlotRouteHelper)

    def invite(prospect, subject, token)
      return unless prospect

      @resource = prospect
      @token = token
      mail to: prospect.email, subject: subject
    end
  end
end
