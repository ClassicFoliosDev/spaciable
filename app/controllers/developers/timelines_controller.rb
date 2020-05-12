# frozen_string_literal: true

module Developers
  class TimelinesController < ApplicationController
    load_and_authorize_resource :developer

    def new
      # Render import - the response is sent directly to the
      # main timeline controller for clone/import
      render :import
    end
  end
end
