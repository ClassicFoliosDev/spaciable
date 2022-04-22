# frozen_string_literal: true

class BrandsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :development
  load_and_authorize_resource :phase
  load_and_authorize_resource :brand, through: %i[developer division development phase],
                                      singleton: true,
                                      except: %i[index new create]

  before_action :set_parent

  def index
    @brand = @parent.brand
    @brand = @parent.brands.build if @brand.nil?
  end

  def new
    @brand = @parent.build_brand
  end

  def create
    @brand = @parent.build_brand(brand_params)
    if @brand.save
      notice = t("controller.success.create", name: @brand)
      redirect_to [@parent, :brands], notice: notice
    else
      render :new
    end
  end

  def update
    if @brand.update(brand_params)
      notice = t("controller.success.update", name: @brand)
      redirect_to [@parent, :brands], notice: notice
    else
      render :edit
    end
  end

  def show; end

  def edit; end

  def destroy
    @brand.destroy
    notice = t("controller.success.destroy", name: @brand)
    redirect_to [@parent, :brands], notice: notice
  end

  private

  def brand_params
    params.require(:brand).permit(
      :logo, :banner, :bg_color, :text_color, :content_bg_color, :content_text_color,
      :button_color, :button_text_color, :header_color,
      :logo_cache, :remove_logo, :banner_cache, :remove_banner,
      :login_image, :topnav_text_color, :login_box_left_color, :login_box_right_color,
      :login_button_static_color, :login_button_hover_color,
      :content_box_color, :content_box_outline_color,
      :content_box_text, :heading_one, :heading_two, :info_text,
      :text_left_color, :text_right_color, :login_logo,
      :login_image_cache, :remove_login_image, :login_logo_cache, :remove_login_logo,
      :email_logo, :remove_email_logo, :email_logo_cache,
      :font, :border_style, :button_style, :hero_height
    )
  end

  def set_parent
    @parent = @brand&.brandable || @development || @division || @developer || @phase
  end
end
