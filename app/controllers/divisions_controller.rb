# frozen_string_literal: true
class DivisionsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :developer
  load_and_authorize_resource :division, through: :developer

  def index
    @divisions = paginate(sort(@divisions, default: :division_name))
  end

  def new
    @division.build_address unless @division.address
  end

  def edit
    @division.build_address unless @division.address
  end

  def show
    @active_tab = params[:active_tab] || "developments"
    @collection = if @active_tab == "developments"
                    paginate(sort(@division.developments, default: :name))
                  elsif @active_tab == "contacts"
                    paginate(sort(@division.contacts, default: :last_name))
                  end
  end

  def create
    if @division.save
      notice = t(
        "controller.success.create",
        name: @division.division_name
      )
      redirect_to [@developer, :divisions], notice: notice
    else
      @division.build_address unless @division.address
      render :new
    end
  end

  def update
    if @division.update(division_params)
      notice = t(
        "controller.success.update",
        name: @division.division_name
      )
      redirect_to [@developer, @division], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @division.destroy
    notice = t(
      "controller.success.destroy",
      name: @division.division_name
    )
    redirect_to [@developer, :divisions], notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def division_params
    params.require(:division).permit(
      :division_name,
      :address,
      :email,
      :contact_number,
      address_attributes: [:postal_name, :road_name, :building_name, :city, :county, :postcode]
    )
  end
end
