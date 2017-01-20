# frozen_string_literal: true
module Admin
  class DivisionsController < ApplicationController
    skip_authorization_check

    def index
      divisions = Division
                  .accessible_by(current_ability)
                  .where(developer_id: params[:developerId])
                  .order(:division_name).map do |division|
        { name: division.to_s, id: division.id, selected: selected?(division) }
      end

      render json: divisions.to_json
    end

    private

    def selected?(division)
      return false unless params[:divisionId].present?

      division.id.to_s == params[:divisionId]
    end
  end
end
