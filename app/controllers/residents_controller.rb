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
      @resident.create_without_password
    else
      @resident = existing_resident
      @resident.update_attributes(invited_by: current_user)
    end

    if @resident&.valid?
      notify_and_redirect(existing_resident.nil?)
    else
      render :new
    end
  end

  def update
    if @resident.update(resident_params)
      notify_and_redirect(false)
    else
      render :edit
    end
  end

  def show
    @plot_residency = PlotResidency.find_by(plot_id: @plot.id, resident_id: @resident.id)
  end

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

  def activation_status
    if @resident.invitation_accepted?
      Rails.configuration.mailchimp[:activated]
    else
      Rails.configuration.mailchimp[:unactivated]
    end
  end

  def notify_and_redirect(new_resident)
    plot_residency = PlotResidency.find_by(resident_id: @resident.id, plot_id: @plot.id)

    notice = if plot_residency && !plot_residency.deleted_at?
               t(".plot_residency_already_exists", email: @resident.email, plot: @plot)
             elsif new_resident
               @resident.save!
               plot_residency_and_invitation(plot_residency)
               Mailchimp::MarketingMailService.call(@resident, @plot, activation_status)
             else
               plot_residency_and_invitation(plot_residency)
               t(".resident_already_exists", plot: @plot)
             end

    redirect_to [@plot, active_tab: :residents], notice: notice
  end

  def plot_residency_and_invitation(plot_residency)
    if plot_residency.nil?
      plot_residency = PlotResidency.create!(resident_id: @resident.id, plot_id: @plot.id)
    else
      plot_residency.update_attributes!(deleted_at: nil)
    end

    # Resident invitation service will not send new invitations if the resident has
    # already accepted a Hoozzi invitation
    ResidentInvitationService.call(plot_residency, current_user, @plot.developer.to_s)
    @resident.developer_email_updates = true
  end

  def resident_params
    params.require(:resident).permit(
      :title,
      :first_name,
      :last_name,
      :email,
      :phone_number
    )
  end
end
