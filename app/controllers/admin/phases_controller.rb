# frozen_string_literal: true

module Admin
  class PhasesController < ApplicationController
    skip_authorization_check

    def index
      selected_id = phase_params[:phaseId].to_i
      phases = Phase
               .accessible_by(current_ability)
               .select(:name, :id)
               .order(:name)

      json = scoped_by_params(phases).map do |phase|
        {
          name: phase.name,
          id: phase.id,
          selected: selected_id == phase.id
        }
      end.to_json

      render json: json
    end

    private

    def phase_params
      params.permit(
        :developerId,
        :phaseId,
        :developmentId,
        :divisionId
      )
    end

    def scoped_by_params(phases)
      if phase_params[:developmentId].present?
        phases.where(development_id: phase_params[:developmentId])

      elsif phase_params[:divisionId].present?
        phases.where(division_id: phase_params[:divisionId])

      elsif phase_params[:developerId].present?
        phases.by_developer_and_developer_divisions(phase_params[:developerId])
      else
        []
      end
    end
  end
end
