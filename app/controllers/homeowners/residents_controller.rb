# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
# Technical debt: need to refactor some of the private methods into separate service
module Homeowners
  class ResidentsController < Homeowners::BaseController
    before_action :plot_residency, only: %i[show create remove_resident]

    after_action only: %i[show] do
      record_event(:view_account)
    end

    def show
      @all_residents = residents_for_my_plot.compact
      @resident = Resident.new
      @resident.plots.push(@plot)
    end

    def edit; end

    # rubocop:disable all
    def update
      if UpdateUserService.call(current_resident, resident_params)
        Mailchimp::MarketingMailService.call(current_resident, @plot)
        notice = t(".success")
        if resident_params[:password_confirmation].present?
          redirect_to new_resident_session_path
        elsif resident_params[:lettings_management].present?
          redirect_to letting_path(current_resident), notice: notice
        elsif session[:onboarding]
          redirect_to welcome_home_path, notice: notice
        else
          redirect_to homeowners_resident_path(current_resident), notice: notice
        end
      else
        render :edit
      end
    end
    # rubocop:enable all

    def create
      return not_allowed if @plot_residency.tenant?

      email_addr = resident_params[:email]

      notice = configure_resident_and_plot(email_addr)
      alert = build_alert(notice, email_addr)

      # In some scenarios, there may be both alert and notice contents:
      # if so the JS will only process the alert
      render json: { alert: alert, notice: notice }, status: :ok
    end

    def destroy
      unless current_resident.valid_password?(params[:password])
        render json: { alert: t(".incorrect_password") }
        return
      end

      ResidentResetService.reset_all_plots_for_resident(current_resident)
      redirect_to new_resident_session_path, notice: t(".success") if current_resident.destroy
    end

    def remove_resident
      resident = Resident.find_by(email: params[:email])
      return not_allowed unless removeable?(resident)

      resident&.plots&.delete(@plot)
      notice = remove_plots(resident)
      render json: { alert: nil, notice: notice }, status: :ok
    end

    private

    def plot_residency
      @plot_residency = PlotResidency.find_by(plot_id: @plot.id, resident_id: current_resident&.id)
    end

    def remove_plots(resident)
      notice = t(".success", email: params[:email])

      if resident.plots.count.zero?
        notice << ResidentResetService.reset_all_plots_for_resident(resident)
        notice << t("residents.destroy.deactivated")
        notice << t("residents.destroy.private_documents") if resident.private_documents.any?
        resident.destroy
      elsif resident.private_documents.any?
        ResidentResetService.transfer_files_and_notify(resident, @plot)
        notice << t("residents.destroy.private_documents")
      end

      notice
    end

    def build_alert(notice, email_addr)
      return t(".already_resident", email: email_addr) if notice == "duplicate_plot_residency"
      return nil if @resident.valid?

      alert = t(".not_created", email: email_addr)
      @resident.errors.full_messages.each do |message|
        alert << " " + message
      end
    end

    def configure_resident_and_plot(email_addr)
      existing_resident = Resident.find_by(email: email_addr)

      if existing_resident.nil?
        build_new_resident_and_residency
        t(".new_invitation", email: email_addr)
      else
        @resident = existing_resident
        build_new_residency
      end
    end

    def build_new_residency
      plot_residency = PlotResidency.new(resident_id: @resident.id, plot_id: @plot.id)
      return "duplicate_plot_residency" unless plot_residency.valid?

      plot_residency.role = resident_params[:role]
      plot_residency.invited_by = current_resident

      plot_residency.save!
      t(".existing_resident", email: @resident.email)
    end

    def build_new_resident_and_residency
      @resident = Resident.new(resident_params)
      @resident.create_without_password
      plot_residency = PlotResidency.create!(resident_id: @resident.id, plot_id: @plot.id)
      plot_residency.update(role: resident_params[:role],
                            invited_by: current_resident)

      ResidentInvitationService.call(plot_residency, current_resident, current_resident.to_s)
      @resident.developer_email_updates = true
      Mailchimp::MarketingMailService.call(@resident, @plot,
                                           Rails.configuration.mailchimp[:unactivated])
    end

    def residents_for_my_plot
      @plot.residents.map do |resident|
        next if resident&.email == current_resident&.email

        {
          email: resident.email,
          name: resident.to_s,
          removeable: removeable?(resident),
          plot_count: resident.plots.count
        }
      end
    end

    def not_allowed
      render json: { alert: nil, notice: nil }, status: :unauthorized
      nil
    end

    def removeable?(resident)
      if current_resident&.plot_residency_homeowner?(@plot)
        return true if resident&.plot_residency_tenant?(@plot)

        if current_resident&.plot_residency_primary_resident?(@plot)
          return true if resident.plot_residency_invited_by(@plot).class == Resident
        elsif resident&.plot_residency_invited_by(@plot) == current_resident
          return true
        end
      end

      false
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resident_params
      params.require(:resident).permit(
        :title, :first_name, :last_name, :password, :password_confirmation, :current_password,
        :developer_email_updates, :cf_email_updates, :telephone_updates,
        :email, :phone_number, :role, :lettings_management
      )
    end
  end
end
# rubocop:enable Metrics/ClassLength
