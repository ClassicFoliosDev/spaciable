# frozen_string_literal: true

class SpotlightsController < ApplicationController
  load_and_authorize_resource :development
  load_and_authorize_resource :spotlight, through: :development, only: %i[index new create]
  load_and_authorize_resource :spotlight, only: %i[show edit update]
  before_action :set_parent

  def index; end

  def new
    (redirect_to root_url unless current_user.cf_admin?) if @parent.expired?
    @spotlight.build
  end

  def edit
    (redirect_to spotlight_path unless current_user.cf_admin?) if @parent.expired?
    @spotlight.build
  end

  def show; end

  def create
    if @spotlight.save
      notice = t("controller.success.create", name: "Spotlight")
      redirect_to [@parent, :spotlights], notice: notice
    else
      render :new
    end
  end

  def update
    if @spotlight.update(spotlight_params)
      delete_images(spotlight_params)
      notice = t("controller.success.update", name: "Shortcut")
      redirect_to [@parent, :spotlights], notice: notice
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

  def spotlight_params
    s_params = params.require(:spotlight).permit(
      :editable, :category,
      custom_tiles_attributes: %i[category feature document_id guide
                                  link tileable_type tileable_id
                                  title render_title description image
                                  render_description button render_button
                                  image_cache remove_image full_image _destroy
                                  id order appears appears_after appears_after_date
                                  file expiry]
    )
    s_params[:custom_tiles_attributes].each { |_, a| a[:remove_image] = "0" if a[:image] }
    s_params
  end

  def delete_images(s_params)
    @spotlight.custom_tiles.each_with_index do |t, i|
      next if s_params[:custom_tiles_attributes][i.to_s][:image]
      t.remove_image! if s_params[:custom_tiles_attributes][i.to_s][:remove_image] == "1"
    end
  end
end
