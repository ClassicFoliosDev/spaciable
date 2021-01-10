# frozen_string_literal: true

module Api
  module V1
    class PreSalesController < Api::AdminController
      def create
        Api::PreSales.new(pre_sales_params).add_limited_access_user do |message, status|
          render json: { message: message }, status: status
          break
        end
      end

      private

      def pre_sales_params
        params.require(:pre_sale).permit(
          :development, :plot_number, :email, :phone_number, :first_name, :last_name
        )
      end
    end
  end
end
