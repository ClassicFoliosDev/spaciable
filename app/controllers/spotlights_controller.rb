# frozen_string_literal: true

class SpotlightsController < ApplicationController
  load_and_authorize_resource :development
  load_and_authorize_resource :spotlight, through: :development, only: %i[index]
  load_and_authorize_resource :spotlight, only: %i[show edit]
  before_action :set_parent

  def index; end

  def new
    (redirect_to root_url unless current_user.cf_admin?) if @parent.expired?
  end

  def edit
    (redirect_to spotlight_path unless current_user.cf_admin?) if @parent.expired?
    @spotlight.build
  end

  def show; end

  def create
    if @custom_tile.save
      notice = t("controller.success.create", name: "Spotlight")
      redirect_to [@parent, :spotlights], notice: notice
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
    @parent = @development || @spotlight.parent
    @brand = @parent&.branding if @parent.present? && @parent.respond_to?(:branding)
  end

  def custom_tile_params
    params.require(:custom_tile).permit(:title, :description, :button, :editable,
                                        :image, :remove_image, :image_cache, :category, :link,
                                        :feature, :guide, :file, :document_id, :development_id,
                                        :tileable_id, :tileable_type, :full_image,
                                        :render_title, :render_description, :render_button,
                                        :appears)
  end
end
