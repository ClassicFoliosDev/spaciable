# frozen_string_literal: true
module Divisions
  class DevelopmentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :division
    load_and_authorize_resource :development, through: :division

    def index
      @developments = paginate(sort(@developments, default: :name))
    end

    def new
      @development.build_address unless @development.address
    end

    def edit
      @development.build_address unless @development.address
    end

    def show
      @active_tab = params[:active_tab] || "unit_types"

      @collection = if @active_tab == "unit_types"
                      paginate(sort(@development.unit_types, default: :name))
                    elsif @active_tab == "phases"
                      paginate(sort(@development.phases, default: :number))
                    elsif @active_tab == "plots"
                      paginate(sort(@development.plots, default: :number))
                    elsif @active_tab == "documents"
                      documents = @development.documents.accessible_by(current_ability)
                      paginate(sort(documents, default: :title))
                    end
    end

    def create
      if @development.save
        notice = Mailchimp::SegmentService.call(@development)
        notice = t(".success", development_name: @development.name) if notice.nil?
        redirect_to [@division, :developments], notice: notice
      else
        @development.build_address unless @development.address
        render :new
      end
    end

    def update
      if @development.update(development_params)
        notice = Mailchimp::SegmentService.call(@development)
        notice = t(".success", development_name: @development.name) if notice.nil?
        redirect_to [@division, @development], notice: notice
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
        :maintenance_link,
        address_attributes: [:postal_name, :road_name, :building_name, :city, :county, :postcode]
      )
    end
  end
end
