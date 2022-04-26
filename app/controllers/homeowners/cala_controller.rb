# frozen_string_literal: true

module Homeowners
  class CalaController < Homeowners::BaseController
    def bt_shop
      return redirect_to root_path, notice: I18n.t("cala.not_res") unless current_resident.cala?
      error, url = Uniqodo.redeem(current_resident.email)
      return redirect_to root_path, notice: error if error
      redirect_to url
    end
  end
end
