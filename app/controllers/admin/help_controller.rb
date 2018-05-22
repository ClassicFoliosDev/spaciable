# frozen_string_literal: true

module Admin
  class HelpController < ApplicationController
    skip_authorization_check

    def show
      @setting = Setting.first
    end
  end
end
