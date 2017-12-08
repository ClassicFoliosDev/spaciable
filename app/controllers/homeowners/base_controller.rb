# frozen_string_literal: true

module Homeowners
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :redirect_residents
    skip_authorization_check

    before_action :authenticate_resident!, :set_unread, if: -> { current_resident }
    before_action :set_plot, :set_brand

    layout "homeowner"

    def current_ability
      if current_user.present?
        @resident ||= Resident.new(email: current_user.email)
        @ability ||= Ability.new(@resident, @plot)
      else
        @ability ||= Ability.new(current_resident, @plot)
      end
    end

    protected

    def set_brand
      @brand ||= @plot&.brand
    end

    def set_plot
      if current_resident.present?
        # TODO: work out correct plot
        @plot = current_resident.plots.first
        session[:plot_id] = @plot.id
      elsif current_user.present?
        plot_id = session[:plot_id]
        @plot = Plot.find(plot_id) if plot_id
      end
    end

    def set_unread
      @unread_count = current_resident.resident_notifications.where(read_at: nil).count || 0
    end
  end
end
