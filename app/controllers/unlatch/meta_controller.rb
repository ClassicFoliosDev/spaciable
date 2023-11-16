# frozen_string_literal: true

module Unlatch
  # rubocop:disable LineLength
  class MetaController < ApplicationController
    after_action :allow_iframe

    layout "unlatch"
    skip_before_action :authenticate_user!
    skip_authorization_check
    before_action :unlatch

    def rooms
      @plot = Unlatch::Lot.find_by(id: params[:lot_id])&.plot
      @rooms = @plot&.rooms
      render (@plot.nil? ? "homeowners/rooms/no_match" : "homeowners/rooms/show")
    end

    def appliances
      @plot = Unlatch::Lot.find_by(id: params[:lot_id])&.plot
      @appliances = @plot&.appliances
      render (@plot.nil? ? "homeowners/appliances/no_match" : "homeowners/appliances/show")
    end

    def unlatch
      @unlatched = true
      @skip_menus = true
    end

    private

    def allow_iframe
      response.headers.except!
      response.set_header("X-Frame-Options", "ALLOWALL")
    end
  end
  # rubocop:enable LineLength
end
