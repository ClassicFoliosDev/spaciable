# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ResidentsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :plot
  load_and_authorize_resource :resident

  before_action :set_plot_residency, only: %i[update show edit reinvite]

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
    end

    if @resident&.valid?
      notify_and_redirect(existing_resident.nil?)
    else
      render :new
    end
  end

  def update
    if @resident.update(resident_params) && @plot_residency.update(resident_role_params)
      notify_and_redirect(false)
    else
      render :edit
    end
  end

  def show; end

  def edit
    (redirect_to plot_resident_path unless current_user.cf_admin?) if @plot.expired?
  end

  def destroy
    resident_homeowner = @resident.plot_residency_homeowner?(@plot)
    @resident.plots.delete(@plot)

    @notice = t(".success", email: @resident.email, plot: @plot)

    remove_tenants if resident_homeowner && all_homeowners.empty?

    if @resident.plots.count.zero?
      remove_resident
    elsif @resident.private_documents.any?
      ResidentResetService.transfer_files_and_notify(@resident, @plot)
      @notice << t("residents.destroy.private_documents")
    end

    redirect_to [@plot, active_tab: :residents], notice: @notice
  end

  def reinvite
    ResidentInvitationService.call(@plot_residency, current_user, @plot.developer.to_s)
    render json: { message: t("resident_reinvited", resident: @resident.to_s) }
  end

  private

  def resident_role_params
    params.require(:resident).permit(:role)
  end

  def set_plot_residency
    @plot_residency = PlotResidency.find_by(plot_id: @plot.id, resident_id: @resident.id)
  end

  def all_homeowners
    @plot.plot_residencies.where(role: nil) + @plot.plot_residencies.where(role: :homeowner)
  end

  def remove_resident
    @notice << ResidentResetService.reset_all_plots_for_resident(@resident)
    @notice << t(".deactivated")
    @notice << t(".private_documents") if @resident.private_documents.any?
    @resident.destroy
  end

  def remove_tenants
    tenant_residencies = @plot.plot_residencies.where(role: :tenant)
    tenants = tenant_residencies.map(&:resident)
    tenants.each do |tenant|
      # Remove tenant from this plot
      tenant.plots.delete(@plot)

      # If this was the only plot, also delete the tenant account
      if tenant.plot_residencies.count.zero?
        ResidentResetService.reset_all_plots_for_resident(tenant)
        tenant.destroy
      elsif tenant.private_documents.any?
        ResidentResetService.transfer_files_and_notify(tenant, @plot)
      end
    end
  end

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
    # Plot residency created by admin is always a homeowner
    if plot_residency.nil?
      plot_residency = PlotResidency.create!(resident_id: @resident.id, plot_id: @plot.id,
                                             role: params[:resident][:role],
                                             invited_by: current_user)
    else
      plot_residency.update_attributes!(deleted_at: nil,
                                        role: params[:resident][:role], invited_by: current_user)
    end

    # Resident invitation service will not send new invitations if the resident has
    # already accepted a previous invitation
    ResidentInvitationService.call(plot_residency, current_user, @plot.developer.to_s)
    @resident.developer_email_updates = true
  end

  def resident_params
    params.require(:resident).permit(:title, :first_name, :last_name, :role, :email, :phone_number)
  end
end
# rubocop:enable Metrics/ClassLength
