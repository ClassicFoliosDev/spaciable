# frozen_string_literal: true
class ServicesController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :service, through: :development

  def index
    @services = paginate(sort(@services, default: :name))
  end

  def new; end

  def edit; end

  def show; end

  def create
    if @service.save
      notice = t("controller.success.create", name: @service.name)
      redirect_to [@development, :services], notice: notice
    else
      render :new
    end
  end

  def update
    if @service.update(service_params)
      notice = t("controller.success.update", name: @service.name)
      redirect_to [@development, :services], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @service.destroy
    notice = t(
      "controller.success.destroy",
      name: @service.name
    )
    redirect_to [@development, :services], notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(
      :name,
      :description
    )
  end
end
