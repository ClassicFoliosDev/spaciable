# frozen_string_literal: true
module Divisions
  class DevelopmentsController < ApplicationController
    load_and_authorize_resource :division
    load_and_authorize_resource :development, through: [:division]

    def index
    end

    def show
    end

    def new
    end

    def edit
    end

    def create
      if @development.save
        redirect_to [@division, @development], notice: "Development was successfully created."
      else
        render :new
      end
    end

    def update
      if @development.update(development_params)
        redirect_to [@division, @development], notice: "Development was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @development.destroy
      redirect_to division_developments_path, notice: "Development was successfully destroyed."
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def development_params
      params.require(:development).permit(
        :name,
        :developer_id,
        :division_id,
        :office_address,
        :city,
        :county,
        :postcode,
        :email,
        :contact_number
      )
    end
  end
end
