# frozen_string_literal: true

module Admin
  class DivisionsController < ApplicationController
    skip_authorization_check

    def index
      selected_id = params[:divisionId].to_i
      divisions = Division
                  .accessible_by(current_ability)
                  .where(developer_id: params[:developerId])
                  .select(:division_name, :id)
                  .order(:division_name).map do |division|
        {
          name: division.division_name,
          id: division.id,
          selected: selected_id == division.id
        }
      end

      render json: divisions.to_json
    end
  end
end
