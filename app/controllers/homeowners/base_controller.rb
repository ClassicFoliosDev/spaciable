# frozen_string_literal: true
module Homeowners
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :redirect_residents
    skip_authorization_check

    before_action :authenticate_resident!, unless: -> { current_user }
    before_action :set_plot, :set_brand

    layout "homeowner"

    def current_ability
      if current_user.present?
        @resident ||= Resident.new(plot: @plot, email: current_user.email)
        @ability ||= Ability.new(@resident)
      else
        @ability ||= Ability.new(current_resident)
      end
    end

    protected

    def set_brand
      @brand ||= @plot&.brand
    end

    def set_plot
      if current_user.present?
        plot_id = session[:plot_id]
        @plot = Plot.find(plot_id) if plot_id
      else
        @plot = current_resident.plot
      end
    end
  end
end
