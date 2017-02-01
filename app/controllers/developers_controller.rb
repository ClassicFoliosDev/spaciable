# frozen_string_literal: true
class DevelopersController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource

  def index
    @developers = paginate(sort(@developers, default: :company_name))
  end

  def new
    @developer.build_address unless @developer.address
  end

  def edit
    @developer.build_address unless @developer.address
  end

  def show
    @active_tab = params[:active_tab] || "divisions"
    @collection = if @active_tab == "divisions"
                    paginate(sort(@developer.divisions, default: :division_name))
                  elsif @active_tab == "developments"
                    paginate(sort(@developer.developments, default: :name))
                  elsif @active_tab == "documents"
                    paginate(sort(@developer.documents, default: :title))
                  elsif @active_tab == "contacts"
                    paginate(sort(@developer.contacts, default: :last_name))
                  end
  end

  def create
    if @developer.save
      redirect_to developers_path, notice: t(".success", developer_name: @developer.company_name)
    else
      @developer.build_address unless @developer.address
      render :new
    end
  end

  def update
    if @developer.update(developer_params)
      notice = t(".success", developer_name: @developer.company_name)
      redirect_to developer_path(@developer), notice: notice
    else
      render :edit
    end
  end

  def destroy
    @developer.destroy

    notice = t(".success", developer_name: @developer.company_name)
    redirect_to developers_url, notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def developer_params
    params.require(:developer).permit(
      :company_name,
      :email,
      :contact_number,
      :about,
      address_attributes: [:postal_name, :road_name, :building_name, :city, :county, :postcode]
    )
  end
end
