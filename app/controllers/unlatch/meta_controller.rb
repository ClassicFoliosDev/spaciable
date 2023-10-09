# frozen_string_literal: true
module Unlatch
  class MetaController < ApplicationController

    after_action :allow_iframe

  	layout "unlatch"
  	skip_before_action :authenticate_user!
  	skip_authorization_check
    before_action :menus_off

    def rooms
    	@plot = Unlatch::Lot.find(params["lot_id"])&.plot
    	@rooms = @plot&.rooms
    	render :template => 'homeowners/rooms/show'
    end

    def appliances
    	@plot = Unlatch::Lot.find(params["lot_id"])&.plot
    	@appliances = @plot&.appliances
    	render :template => 'homeowners/appliances/show'
    end

    def menus_off
      @skip_menus = true
    end

    private

  def allow_iframe
    response.headers.except! 
    response.set_header('X-Frame-Options', 'ALLOWALL')
  end

  end
end
