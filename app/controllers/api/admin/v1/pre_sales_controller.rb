# frozen_string_literal: true

module Api
  module Admin
    module V1
      class PreSalesController < Api::Admin::AdminController
        METHODS ||= %w[create single_page_app_create].freeze

        METHODS.each do |endpoint|
          define_method endpoint do
            Api::PreSales.new(pre_sale_params).add_limited_access_user do |m, s, h_s|
              render json: { message: m, result: s }, status: h_s
              break
            end
          end
        end

        private

        def pre_sale_params
          params.require(:pre_sale).permit(
            :development, :division, :phase, :plot_number,
            :email, :phone_number, :title, :first_name, :last_name
          )
        end
      end
    end
  end
end
