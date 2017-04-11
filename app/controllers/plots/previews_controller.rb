# frozen_string_literal: true
module Plots
  class PreviewsController < ApplicationController
    skip_authorization_check
    skip_before_action :redirect_residents

    def show
      @target = params[:target]
    end
  end
end
