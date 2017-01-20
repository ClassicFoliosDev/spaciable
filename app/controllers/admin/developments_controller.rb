# frozen_string_literal: true
module Admin
  class DevelopmentsController < ApplicationController
    skip_authorization_check

    def index
      developments = Development
                     .accessible_by(current_ability)
                     .order(:name)

      json = scoped_by_params(developments).map do |development|
        { name: development.to_s, id: development.id, selected: selected?(development) }
      end.to_json

      render json: json
    end

    private

    def scoped_by_params(developments)
      if params[:divisionId].present?
        developments.where(division_id: params[:divisionId])

      elsif params[:developerId].present?
        developments.by_developer_and_developer_divisions(params[:developerId])
      else
        []
      end
    end

    def selected?(development)
      return false unless params[:developmentId].present?

      development.id.to_s == params[:developmentId]
    end
  end
end
