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

    def development_params
      params.permit(
        :developmentId,
        :divisionId,
        :developerId
      )
    end

    def scoped_by_params(developments)
      if params[:divisionId].present?
        developments.where(division_id: development_params[:divisionId])

      elsif params[:developerId].present?
        developments.by_developer_and_developer_divisions(development_params[:developerId])
      else
        []
      end
    end

    def selected?(development)
      return false unless development_params[:developmentId].present?

      development.id.to_s == development_params[:developmentId]
    end
  end
end
