# frozen_string_literal: true
module Admin
  class DevelopersController < ApplicationController
    skip_authorization_check

    def index
      developers = Developer.accessible_by(current_ability).order(:company_name).map do |developer|
        { name: developer.to_s, id: developer.id, selected: selected?(developer) }
      end

      render json: developers.to_json
    end

    private

    def selected?(developer)
      return false unless params[:developerId].present?

      developer.id.to_s == params[:developerId]
    end
  end
end
