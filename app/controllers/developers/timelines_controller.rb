# frozen_string_literal: true

module Developers
  class TimelinesController < ApplicationController
    load_and_authorize_resource :developer

    def new
      render :import
    end
  end
end
