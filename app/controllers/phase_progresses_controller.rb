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
    if @phase.plots.update_attributes(progress: state)
      notice = t(".success", progress: t("activerecord.attributes.plot.progresses.#{state}"))
      if params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@phase, current_user, t("plot_details"))
      end

      redirect_to [@phase, :phase_progresses], notice: notice
    else
      render :edit
    end
  end
end
