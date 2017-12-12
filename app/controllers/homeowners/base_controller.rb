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
      else
        @resident = current_resident
      end
      @ability ||= Ability.new(@resident, @plot)
    end

    def change_plot
      @plot = Plot.find(params[:id])
      @brand = @plot&.brand
      session[:plot_id] = @plot.id
      redirect_to homeowner_dashboard_path
    end

    protected

    def set_brand
      @brand ||= @plot&.brand
    end

    def set_plot
      plot_id = session[:plot_id]
      @plot = if plot_id
                Plot.find(plot_id)
              else
                current_resident.plots.first
              end
      if current_resident.present?
        session[:plot_id] = @plot.id
        @plots = current_resident.plots
      elsif current_user.present?
        @plots = [@plot]
      end
    end

    def set_unread
      @unread_count = current_resident.resident_notifications.where(read_at: nil).count || 0
    end
  end
end
