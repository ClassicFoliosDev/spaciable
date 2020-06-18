# frozen_string_literal: true

module Phases
  class ImportController < ApplicationController
    load_and_authorize_resource :phase

    def index; end
  end
end
