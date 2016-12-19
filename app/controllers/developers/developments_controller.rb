# frozen_string_literal: true
module Developers
  class DevelopmentsController < ApplicationController
    include PaginationConcern
    load_and_authorize_resource :developer
    load_and_authorize_resource :development, through: [:developer]

    def index
      @developments = paginate(@developments)
    end

    def show
    end

    def new
    end

    def edit
    end

    def create
      if @development.save
        notice = t(".success", development_name: @development.name)
        redirect_to [@developer, :developments], notice: notice
      else
        render :new
      end
    end

    def update
      if @development.update(development_params)
        notice = t(".success", development_name: @development.name)
        redirect_to [@developer, :developments], notice: notice
      else
        render :edit
      end
    end

    def destroy
      notice = t(".archive.success", development_name: @development.name)

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
        :postal_name,
        :building_name,
        :road_name,
        :city,
        :county,
        :postcode,
        :email,
        :contact_number
      )
    end
  end
end
