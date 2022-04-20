# frozen_string_literal: true

module Homeowners
  class CalaController < Homeowners::BaseController
    def bt_shop
      return redirect_to root_path, notice: "You do not quaify for this offer" unless false
      redirect_to "http://www.overlander.bike"
    end
  end
end
