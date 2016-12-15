# frozen_string_literal: true
class DevelopersController < ApplicationController
  include PaginationConcern
  load_and_authorize_resource

  def index
    @developers = paginate(@developers).order(:company_name)
  end

  def new
  end

  def edit
  end

  def create
    if @developer.save
      redirect_to developers_path, notice: t(".success", developer_name: @developer.company_name)
    else
      render :new
    end
  end

  def update
    if @developer.update(developer_params)
      redirect_to developers_path, notice: t(".success", developer_name: @developer.company_name)
    else
      render :edit
    end
  end

  def destroy
    @developer.destroy

    notice = t(".archive.success", developer_name: @developer.company_name)
    redirect_to developers_url, notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def developer_params
    params.require(:developer).permit(
      :company_name,
      :postal_name,
      :road_name,
      :building_name,
      :city,
      :county,
      :postcode,
      :email,
      :contact_number,
      :about
    )
  end
end
