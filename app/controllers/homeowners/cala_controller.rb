# frozen_string_literal: true

module Homeowners
  class CalaController < Homeowners::BaseController
    # rubocop:disable LineLength, OutputSafety
    def bt_shop
      return redirect_to root_path, alert: I18n.t("cala.not_res").html_safe unless current_resident.cala?(params.key?("pemd"))
      error, url = Uniqodo.redeem("13482", current_resident.email)
      return redirect_to root_path, alert: error if error
      redirect_to url
    end

    def offers
      return redirect_to root_path, alert: I18n.t("cala.not_res").html_safe unless current_resident.cala?(params.key?("pemd"))
      error, url = Uniqodo.redeem(params[:offer_code], current_resident.email)
      return redirect_to root_path, alert: error if error
      redirect_to url
    end
  end
end
