# frozen_string_literal: true
module Developers
  class DevelopmentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :developer
    load_and_authorize_resource :development, through: [:developer]

    def index
      @developments = paginate(sort(@developments, default: :name))
    end

    def show
      @active_tab = params[:active_tab] || "unit_types"

      @collection = if @active_tab == "unit_types"
                      paginate(sort(@development.unit_types, default: :name))
                    elsif @active_tab == "phases"
                      paginate(sort(@development.phases, default: :number))
                    end
    end

    def new
      @development.build_address unless @development.address
    end

    def edit
      @development.build_address unless @development.address
    end

    def create
      if @development.save
        notice = t(".success", development_name: @development.name)
        redirect_to [@developer, :developments], notice: notice
      else
        @development.build_address unless @development.address
        render :new
      end
    end

    def update
      if @development.update(development_params)
        notice = t(".success", development_name: @development.name)
        redirect_to [@developer, @development], notice: notice
      else
        @development.build_address unless @development.address
        render :edit
      end
    end

    def destroy
      notice = t(".success", development_name: @development.name)

      @development.destroy
      redirect_to [@developer, :developments], notice: notice
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def development_params
      params.require(:development).permit(
        :name,
        :developer_id,
        :division_id,
        :email,
        :contact_number,
        address_attributes: [:postal_name, :road_name, :building_name, :city, :county, :postcode]
      )
    end
  end
end
