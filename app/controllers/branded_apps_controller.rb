# frozen_string_literal: true

class BrandedAppsController < ApplicationController
  load_and_authorize_resource :developer
  load_and_authorize_resource :branded_app,
                              through: %i[developer],
                              shallow: true

  before_action :set_parent

  def index
    @branded_app = @parent.branded_app
  end

  def new
    @branded_app = BrandedApp.new
  end

  def create; end

  def edit; end

  def update
    if @branded_app.update(branded_app_params)
      notice = t("controller.success.update", name: "#{@parent} Branded App")
      redirect_to [@parent, :branded_apps], notice: notice
    else
      render :index
    end
  end

  def destroy; end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def branded_app_params
    params.require(:branded_app).permit(
      :app_owner_id, :app_owner_type,
      :android_link, :apple_link, :app_icon,
      :app_icon_cache, :remove_app_icon
    )
  end

  def set_parent
    @parent = @developer || @branded_app&.app_owner
    @branded_app&.app_owner = @parent
  end
end
