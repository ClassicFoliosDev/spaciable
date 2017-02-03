# frozen_string_literal: true
class BrandsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :development
  load_and_authorize_resource :brand, through: [:developer, :division, :development], shallow: true

  before_action :set_parent

  def index
    @collection = paginate(sort(@parent.brands, default: :logo))
    @brand = @parent.brands.build
  end

  def new
  end

  def create
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

  def show
  end

  def edit
  end

  def destroy
    @brand.destroy
    notice = t("controller.success.destroy", name: @brand)
    redirect_to [@parent, :brands], notice: notice
  end

  private

  def brand_params
    params.require(:brand).permit(
      :logo,
      :banner,
      :bg_color,
      :text_color,
      :content_bg_color,
      :content_text_color,
      :button_color,
      :button_text_color
    )
  end

  def set_parent
    @parent = @brand&.brandable || @developer || @division || @development
  end
end
