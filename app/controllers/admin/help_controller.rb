# frozen_string_literal: true

module Admin
  class HelpController < ApplicationController
    skip_authorization_check

    def show; end
  end
end
