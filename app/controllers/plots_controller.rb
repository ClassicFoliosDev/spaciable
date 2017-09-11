# frozen_string_literal: true
class PlotsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :phase
  load_and_authorize_resource :plot, through: [:development, :phase], shallow: true

  before_action :set_parent

  def index
    @plots = @plots.includes(:unit_type)
    @plots = paginate(sort(@plots, default: :number))
    @plot = @parent.plots.build
  end

  def new
    @plots = BulkPlots::CreateService.call(@plot).collection
    @plot.progress = :soon
  end

  def edit
    @plots = BulkPlots::UpdateService.call(@plot).collection
  end

  def show
    documents = @plot.documents
    @active_tab = "documents"
    @collection_parent = @plot
    @collection = paginate(sort(documents, default: :title))

    session[:plot_id] = @plot.id
  end

  def create
    BulkPlots::CreateService.call(@plot, params: plot_params) do |service, created_plots, errors|
      if created_plots.any?
        notice = t(".success", plots: created_plots.to_sentence, count: created_plots.count)

        redirect_to [@parent, :plots], notice: notice, alert: errors
      else
        flash.now[:alert] = errors if errors
        @plots = service.collection
        @plot.progress = :soon

        render :new
      end
    end
  end

  def update
    BulkPlots::UpdateService.call(@plot, params: plot_params) do |service, updated_plots, errors|
      if updated_plots.any?
        notice = t(".success", plot_name: updated_plots.to_sentence, count: updated_plots.count)
        if plot_params[:notify].to_i.positive?
          notice << ResidentChangeNotifyService.call(@plot, current_user, t("plot_details"))
        end
        redirect_to [@parent, :plots], notice: notice, alert: errors
      else
        flash.now[:alert] = errors if errors
        @plots = service.collection

        render :edit
      end
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
      [:range_from, :range_to, :list].concat(plot_attributes)
    )
  end

  def create_params
    params.require(:plot).permit(plot_attributes)
  end

  def plot_attributes
    [
      :prefix, :number,
      :unit_type_id,
      :house_number,
      :road_name,
      :building_name,
      :locality,
      :city, :county,
      :postcode, :progress,
      :notify, :user_id
    ]
  end

  def set_parent
    @parent ||= @phase || @development || @plot&.parent
  end
end
