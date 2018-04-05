# frozen_string_literal: true

module Homeowners
  class ResidentsController < Homeowners::BaseController
    def show
      @services = Service.all
      @all_residents = residents_for_my_plot.compact
      @resident = Resident.new
      @resident.plots.push(@plot)
    end

    def edit
      @services = Service.all.includes(:residents)
    end

    def update
      if UpdateUserService.call(current_resident, resident_params)
        Mailchimp::MarketingMailService.call(current_resident, @plot)
        notice = t(".success")
        notice += process_service_ids(params[:services])
        redirect_to root_path, notice: notice
      else
        render :edit
      end
    end

    def create
      if current_resident.invited_by_type != "User"
        render json: { alert: nil, notice: nil }, status: 401
        return
      end

      email_addr = resident_params[:email]

      notice = configure_resident_and_plot(email_addr)
      alert = build_alert(notice, email_addr)

      # In some scenarios, there may be both alert and notice contents:
      # if so the JS will only process the alert
      render json: { alert: alert, notice: notice }, status: :ok
    end

    def remove_resident
      if current_resident.invited_by_type != "User"
        render json: { alert: nil, notice: nil }, status: 401
        return
      end

      resident = Resident.find_by(email: params[:email])
      resident.plots.delete(@plot)

      render json: { alert: nil, notice: t(".success", email: params[:email]) }, status: :ok
    end

    private

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

      plot_residency.save!
      t(".existing_resident", email: @resident.email)
    end

    def build_new_resident_and_residency
      @resident = Resident.new(resident_params)
      @resident.create_without_password
      plot_residency = PlotResidency.create!(resident_id: @resident.id, plot_id: @plot.id)
      ResidentInvitationService.call(plot_residency, current_resident, current_resident.to_s)
      @resident.developer_email_updates = true
      Mailchimp::MarketingMailService.call(@resident, @plot,
                                           Rails.configuration.mailchimp[:unactivated])
    end

    def residents_for_my_plot
      @plot.residents.map do |resident|
        next if resident.email == current_resident.email
        { email: resident.email, name: resident.to_s }
      end
    end

    def process_service_ids(service_params)
      service_ids = []

      # The service params are wrapped in an array, all
      # the ids are in the first entry
      service_params&.first&.each do |param|
        service_ids.push(param.to_i)
      end

      service_count = ResidentServicesService.call(current_resident, service_ids, true, @plot)
      return t(".updated_services") if service_count.positive?

      ""
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resident_params
      params.require(:resident).permit(
        :title,
        :first_name, :last_name,
        :password, :password_confirmation,
        :current_password,
        :developer_email_updates,
        :hoozzi_email_updates,
        :telephone_updates, :post_updates,
        :email, :phone_number
      )
    end
  end
end
