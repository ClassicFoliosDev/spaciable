# frozen_string_literal: true

class ResidentsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :plot
  load_and_authorize_resource :resident

  def index
    @residents = @plot.residents

    @residents = paginate(sort(@residents, default: "residents.last_name"))
  end

  def new; end

  def create
    existing_resident = Resident.find_by(email: resident_params[:email])
    if existing_resident.nil?
      # TODO: completion date
      @resident.create_without_password
    else
      @resident = existing_resident
    end

    if @resident
      notify_and_redirect(existing_resident.nil?)
    else
      render :new
    end
  end

  def update
    if @resident.update(resident_params)
      plot_residency = PlotResidency.find_by(resident_id: @resident.id, plot_id: @plot.id)
      notice = Mailchimp::MarketingMailService.call(@resident,
                                                    plot_residency,
                                                    Rails.configuration.mailchimp[:unactivated])
      notice = t(".success", resident_name: @resident) if notice.nil?
      redirect_to [@resident.plots.first, active_tab: :residents], notice: notice
    else
      render :edit
    end
  end

  def show; end

  def edit; end

  def destroy
    @resident.plots.delete(@plot)
    notice = t(".success", plot: @plot)

    if @resident.plots.count.zero?
      notice << ResidentResetService.reset_all_plots_for_resident(@resident)
    end

    redirect_to [@plot, active_tab: :residents], notice: notice
  end

  private

  def notify_and_redirect(new)
    plot_residency = PlotResidency.create(resident_id: @resident.id, plot_id: @plot.id)
    # Resident invitation service will not send new invitations if the resident has
    # already accepted a Hoozzi invitation
    ResidentInvitationService.call(plot_residency, current_user)
    @resident.developer_email_updates = true

    if new
      notice = Mailchimp::MarketingMailService.call(@resident,
                                                    plot_residency,
                                                    Rails.configuration.mailchimp[:unactivated])
    end

    notice = t(".success", plot: @plot) if notice.nil?
    redirect_to [@plot, active_tab: :residents], notice: notice
  end

  def resident_params
    params.require(:resident).permit(
      :title,
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :completion_date
    )
  end
end
