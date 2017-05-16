# frozen_string_literal: true
module Plots
  class PreviewsController < ApplicationController
    skip_authorization_check
    skip_before_action :redirect_residents

    def show
      @plot = Plot.find(params[:plot_id])
    end
  end
end
