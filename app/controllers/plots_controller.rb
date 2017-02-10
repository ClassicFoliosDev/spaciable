# frozen_string_literal: true
class PlotsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :development
  load_and_authorize_resource :phase
  load_and_authorize_resource :plot, through: [:development, :phase], shallow: true

  before_action :set_parent

  def index
    @plots = paginate(sort(@plots, default: :number))
    @plot = @parent.plots.build
  end

  def new
    @plot.build_address_with_defaults
  end

  def edit
    @plot.build_address_with_defaults
  end

  def show
    @active_tab = params[:active_tab] || "rooms"

    @collection = if @active_tab == "rooms"
                    paginate(sort(@plot.rooms, default: :name))
                  elsif @active_tab == "residents"
                    paginate(sort(@plot.plot_residents, default: :id))
                  end
  end

  def create
    @plot.keep_parent_address(@parent)

    if @plot.save
      notice = t(".success", plot_name: @plot)
      redirect_to [@parent, :plots], notice: notice
    else
      @plot.build_address_with_defaults
      render :new
    end
  end

  def update
    @plot.keep_parent_address(@parent)

    if @plot.update(plot_params)
      notice = t(".success", plot_name: @plot.to_s)
      redirect_to [@parent, :plots], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @plot.destroy
    notice = t(".success", plot_name: @plot.to_s)
    redirect_to [@parent, :plots], notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def plot_params
    params.require(:plot).permit(
      :prefix,
      :number,
      :unit_type_id,
      :house_number,
      address_attributes: [:postal_name,
                           :road_name,
                           :building_name,
                           :city,
                           :county,
                           :postcode,
                           :id]
    )
  end

  def set_parent
    @parent ||= @phase || @development || @plot&.parent
  end
end
