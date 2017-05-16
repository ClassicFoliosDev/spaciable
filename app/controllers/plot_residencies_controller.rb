# frozen_string_literal: true
class PlotResidenciesController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :plot
  load_and_authorize_resource :plot_residency,
                              through: :plot,
                              shallow: true,
                              singleton: true,
                              except: :index

  def index
    @new_residency = PlotResidency.new(plot_id: @plot.id)
    authorize! :index, @new_residency

    @residencies = PlotResidency
                   .includes(:resident)
                   .accessible_by(current_ability)
                   .where(plot_id: @plot)

    @residencies = paginate(sort(@residencies, default: "residents.last_name"))
  end

  def new
    @plot_residency.build_resident
  end

  def create
    if @plot_residency.save
      @plot_residency.resident.invite!(current_user)
      notice = Mailchimp::MarketingMailService.call(@plot_residency.resident,
                                                    @plot_residency,
                                                    Rails.configuration.mailchimp[:unactivated])
      notice = t(".success", plot: @plot_residency.plot) if notice.nil?
      redirect_to [@plot, :plot_residencies], notice: notice
    else
      render :new
    end
  end

  def update
    if @plot_residency.update(plot_residency_params)
      notice = Mailchimp::MarketingMailService.call(@plot_residency.resident,
                                                    @plot_residency)
      notice = t(".success", resident_name: @plot_residency.resident) if notice.nil?
      redirect_to [@plot_residency.plot, :plot_residencies], notice: notice
    else
      render :edit
    end
  end

  def show; end

  def edit; end

  def destroy
    if @plot_residency.destroy
      @plot_residency.plot.development.name = nil
      notice = Mailchimp::MarketingMailService.call(@plot_residency.resident,
                                                    @plot_residency,
                                                    Rails.configuration.mailchimp[:unassigned])
      notice = t(".success", plot: @plot_residency.plot) if notice.nil?
    end

    redirect_to [@plot_residency.plot, :plot_residencies], notice: notice
  end

  private

  def plot_residency_params
    params.require(:plot_residency).permit(
      :title,
      :first_name,
      :last_name,
      :email,
      :completion_date
    )
  end
end
