# frozen_string_literal: true
module Divisions
  class DevelopmentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :division
    load_and_authorize_resource :development, through: :division

    def index
      @collection = paginate(sort(@developments, default: :name))
    end

    def new
      @development.build_address unless @development.address
    end

    def edit
      @development.build_address unless @development.address
    end

    def show
    end

    def create
      if @development.save
        notice = t(".success", development_name: @development.name)
        redirect_to [@division, :developments], notice: notice
      else
        @development.build_address unless @development.address
        render :new
      end
    end

    def update
      if @development.update(development_params)
        notice = t(".success", development_name: @development.name)
        redirect_to [@division, :developments], notice: notice
      else
        @development.build_address unless @development.address
        render :edit
      end
    end

    def destroy
      notice = t(".success", development_name: @development.name)

      @development.destroy
      redirect_to division_developments_path, notice: notice
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def development_params
      params.require(:development).permit(
        :name,
        :division_id,
        :email,
        :contact_number,
        address_attributes: [:postal_name, :road_name, :building_name, :city, :county, :postcode]
      )
    end
  end
end
