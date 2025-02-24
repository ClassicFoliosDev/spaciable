# frozen_string_literal: true

module Homeowners
  class MaterialInfoController < Homeowners::BaseController
    skip_authorization_check

    after_action only: %i[show] do
      record_event(:material_info)
    end

    def show
      @material_info = @plot.material_info
    end
  end
end
