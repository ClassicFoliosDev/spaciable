# frozen_string_literal: true

class PhaseProgressesController < ApplicationController
  include SortingConcern

  load_and_authorize_resource :phase

  def index
    @plots = sort(@phase.plots, default: :number)
    @resident_count = @phase.plot_residencies.size
    @subscribed_resident_count = @phase.residents.where(hoozzi_email_updates: true).size
  end

  def bulk_update
    state = params[:phase_progress_all]
    result = @phase.plots.each do |plot|
      plot.update_attributes(progress: state)
    end
    if result
      notice = notify(state)
      redirect_to [@phase, :phase_progresses], notice: notice
    else
      render :edit
    end
  end

  private

  def notify(state)
    new_state = t("activerecord.attributes.plot.progresses.#{state}")
    notice = t(".success", progress: new_state)
    return notice if params[:notify].to_i.zero?
    notice << ResidentChangeNotifyService.call(@phase.plots.first, current_user,
                                               t("notify.updated_state", state: new_state), @phase)
  end
end
