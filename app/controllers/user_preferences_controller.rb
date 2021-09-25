# frozen_string_literal: true

class UserPreferencesController < ApplicationController
  before_action :authorize_preference, only: [:preference]

  def preference
    render json: { on: @preference.present? ? @preference.on : true }
  end

  def set_preference
    authorize! :set_preference, UserPreference, current_user.id

    preference = UserPreference.where(user_id: current_user.id,
                                      preference: params[:preference])
                               .first_or_initialize
    preference.on = params[:on]
    preference.save
    render json: { success: true }
  end

  def authorize_preference
    authorize! :preference, UserPreference
    @preference = UserPreference.find_by(user_id: current_user.id,
                                         preference: params[:preference])
    authorize! :preference, @preference
  end
end
