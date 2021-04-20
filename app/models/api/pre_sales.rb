# frozen_string_literal: true

module Api
  class PreSales
    FAILED_TO_FIND = 1
    ALREADY_ALLOCATED = 2
    ADDED_NEW = 3
    ADDED_EXISTING = 4

    def initialize(params)
      @params = params
      @params[:title] = @params[:title].downcase
      find_plot
    end

    def add_limited_access_user
      yield(@message, FAILED_TO_FIND, 501) unless @plot

      @tenant = existing = Resident.find_by(email: @params[:email])

      if @tenant.nil?
        @tenant = Api::Tenant.new(@params.except(:development, :division, :phase, :plot_number))
        @tenant.developer_email_updates = true
        @tenant.create_without_password
      end

      yield(@tenant.errors.messages, 501) unless @tenant&.valid?

      notify_and_redirect(existing.nil?) do |message, status|
        yield message, status
      end
    end

    private

    # rubocop:disable Metrics/MethodLength
    def find_plot
      @plot = begin
        if @params[:division]
          Plot.joins(:development, :division, :developer, :phase)
              .find_by(number: @params[:plot_number],
                       phases: { name: @params[:phase] },
                       developments: { name: @params[:development] },
                       divisions: { division_name: @params[:division] },
                       developers: { id: RequestStore.store[:current_user].developer })
        else
          Plot.joins(:development, :developer, :phase)
              .find_by(number: @params[:plot_number],
                       phases: { name: @params[:phase] },
                       developments: { name: @params[:development] },
                       developers: { id: RequestStore.store[:current_user].developer })
        end
      end

      return if @plot

      @message = I18n.t("api.pre_sales.invalid_plot_development",
                        development: @params[:development],
                        phase: @params[:phase],
                        plot_number: @params[:plot_number])
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def notify_and_redirect(new_tenant)
      plot_residency = PlotResidency.find_by(resident_id: @tenant.id, plot_id: @plot.id)

      if plot_residency && !plot_residency.deleted_at?
        yield I18n.t("residents.create.plot_residency_already_exists",
                     email: @tenant.email, plot: @plot), ALREADY_ALLOCATED, 501
      elsif new_tenant
        plot_residency_and_invitation(plot_residency)
        Mailchimp::MarketingMailService.call(@tenant, @plot, activation_status)
        yield I18n.t("residents.create.resident_added",
                     name: @tenant.full_name,
                     plot_number: @plot.number,
                     development: @params[:development],
                     email: @params[:email]), ADDED_NEW, 201
      else
        plot_residency_and_invitation(plot_residency)
        yield I18n.t("residents.create.existing_resident_added",
                     name: @tenant.full_name,
                     plot_number: @plot.number,
                     development: @params[:development]), ADDED_EXISTING, 201
      end
    end
    # rubocop:enable Metrics/MethodLength

    def plot_residency_and_invitation(plot_residency)
      # Plot residency created by admin is always a homeowner
      if plot_residency.nil?
        plot_residency = PlotResidency.create!(resident_id: @tenant.id, plot_id: @plot.id,
                                               role: :tenant,
                                               invited_by: RequestStore.store[:current_user])
      else
        plot_residency.update_attributes!(deleted_at: nil,
                                          role: :tenant,
                                          invited_by: RequestStore.store[:current_user])
      end

      # Resident invitation service will not send new invitations if the resident has
      # already accepted a previous invitation
      ResidentInvitationService.call(plot_residency,
                                     RequestStore.store[:current_user], @plot.developer.to_s,
                                     @tenant)
    end

    def activation_status
      if @tenant.invitation_accepted?
        Rails.configuration.mailchimp[:activated]
      else
        Rails.configuration.mailchimp[:unactivated]
      end
    end
  end
end
