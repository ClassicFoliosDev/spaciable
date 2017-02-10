# frozen_string_literal: true
module Homeowners
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :redirect_residents

    before_action :authenticate_resident!

    layout "homeowner"
  end
end
