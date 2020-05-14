# frozen_string_literal: true

class CustomTilesController < ApplicationController
  load_and_authorize_resource :development
  load_and_authorize_resource :custom_tile, through: :development, shallow: true
  before_action :set_parent

  def index; end

  def new
    (redirect_to root_url unless current_user.cf_admin?) if @parent.expired?
  end

  def edit
    (redirect_to custom_tile_path unless current_user.cf_admin?) if @parent.expired?
  end

  def show; end

  def create
    if @custom_tile.save
      notice = t("controller.success.create", name: "Shortcut")
      redirect_to [@parent, :custom_tiles], notice: notice
    else
      render :new
    end
  end

  def update
    if @custom_tile.update(custom_tile_params)
      notice = t("controller.success.update", name: "Shortcut")
      redirect_to [@parent, :custom_tiles], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @custom_tile.destroy
    notice = t("controller.success.destroy", name: "Shortcut")
    redirect_to [@parent, :custom_tiles], notice: notice
  end

  private

  def set_parent
    @parent = @development || @custom_tile&.parent
  end

  def custom_tile_params
    params.require(:custom_tile).permit(:title, :description, :button, :image, :category, :link,
                                     :feature, :guide, :file, :document_id, :development_id)
  end

end
