# frozen_string_literal: true
module Admin
  class DevelopersController < ApplicationController
    skip_authorization_check

    def index
      selected_id = developer_params[:developerId].to_i
      developers = Developer
                   .accessible_by(current_ability)
                   .select(:company_name, :id)
                   .order(:company_name).map do |developer|
        {
          name: developer.company_name,
          id: developer.id,
          selected: selected_id == developer.id
        }
      end

      render json: developers.to_json
    end

    private

    def developer_params
      params.permit(:developerId)
    end
  end
end
