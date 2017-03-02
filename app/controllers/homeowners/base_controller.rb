# frozen_string_literal: true
module Homeowners
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :redirect_residents

    before_action :authenticate_resident!
    before_action :set_brand, :set_plot

    layout "homeowner"

    def current_ability
      @ability ||= Ability.new(current_resident)
    end

    protected

    def set_brand
      @brand = current_resident.brand
    end

    def set_plot
      @plot = current_resident.plot
    end
  end
end
