# frozen_string_literal: true

class ProgressesController < ApplicationController
  include SortingConcern

  load_and_authorize_resource :phase, only: %i[index bulk_update]
  load_and_authorize_resource :plot, only: [:show]

  def index
    @plots = sort(@phase.plots, default: :number)
    @resident_count = @phase.plot_residencies.size
    @subscribed_resident_count = @phase.residents.where(cf_email_updates: true).size
  end

  def show
    @plot = Plot.find(params[:id])
    @progress_id = Plot.progresses[@plot.progress.to_sym]
  end

  def bulk_update
    state = params[:progress_all]
    result = @phase.plots.each do |plot|
      plot.update_attributes(progress: state) unless plot.expired?
    end

    if result
      notice = notify(state)
      redirect_to [@phase.parent, @phase, active_tab: :plots], notice: notice
    else
      render :edit
    end
  end

  private

  def notify(state)
    new_state = t("activerecord.attributes.plot.progresses.#{state}")
    notice = t(".success", progress: new_state)
    return notice if params[:notify].to_i.zero?

    notice << ResidentChangeNotifyService.call(:not_set, current_user,
                                               t("notify.updated_progress",
                                                 state: new_state), @phase)

    notice
  end
end
