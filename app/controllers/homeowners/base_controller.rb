# frozen_string_literal: true

module Homeowners
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :redirect_residents
    skip_authorization_check

    before_action :authenticate_resident!, :set_unread, if: -> { current_resident }
    before_action :validate_ts_and_cs, :set_plot, :set_brand

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

      @plot = Plot.find(plot_id) if plot_id

      if current_resident.present?
        @plots = current_resident.plots.includes(:developer, :address,
                                                 phase: :address,
                                                 development: %i[brand division],
                                                 division: %i[brand developer])
        @plot = @plots.first if @plot.nil?
        session[:plot_id] = @plot.id
      elsif current_user.present?
        @plots = [@plot]
      end

      redirect_to new_resident_session_path if @plot.nil?
    end

    def set_unread
      @unread_count = current_resident.resident_notifications.where(read_at: nil).count || 0
    end

    def validate_ts_and_cs
      return if current_resident.nil?
      return if current_resident.ts_and_cs_accepted_at.present?

      cookies.delete :ts_and_cs_accepted
      sign_out_all_scopes
      flash[:alert] = t("residents.sessions.create.ts_and_cs_required")
    end
  end
end
