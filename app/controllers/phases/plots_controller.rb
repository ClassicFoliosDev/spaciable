# frozen_string_literal: true
module Phases
  class PlotsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :phase
    load_and_authorize_resource :plot, through: :phase

    def index
      @plots = paginate(sort(@plots, default: :number))
    end

    def new
    end

    def edit
    end

    def show
    end

    def create
      if @plot.save
        notice = t(".success", plot_name: @plot.to_s)
        redirect_to [@phase, :plots], notice: notice
      else
        render :new
      end
    end

    def update
      if @plot.update(plot_params)
        notice = t(".success", plot_name: @plot.to_s)
        redirect_to [@phase, :plots], notice: notice
      else
        render :edit
      end
    end

    def destroy
      @plot.destroy
      notice = t(".success", plot_name: @plot.to_s)
      redirect_to phase_plots_url(@phase), notice: notice
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def plot_params
      params.require(:plot).permit(
        :prefix,
        :number,
        :apartment_prefix,
        :unit_type_id
      )
    end
  end
end
