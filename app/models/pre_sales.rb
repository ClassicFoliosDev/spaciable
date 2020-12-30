# frozen_string_literal: true

class PreSales
  def initialize(params)
    @params = params
    find_plot
  end

  def add_limited_access_user
    yield(@message, 501) unless @plot

    @resident = existing = Resident.find_by(email: @params[:email])

    if @resident.nil?
      @resident = Resident.new(@params.except(:development, :plot_number))
      @resident.create_without_password
      @resident.developer_email_updates = true
    end

    yield(@resident.errors.messages, 501) unless @resident&.valid?

    notify_and_redirect(existing.nil?) do |message, status|
      yield message, status
    end
  end

  private

  def find_plot
    @plot = Plot.joins(:development, :developer)
                .find_by(number: @params[:plot_number],
                         developments: { name: @params[:development] },
                         developers: { id: RequestStore.store[:current_user].developer })

    return if @plot

    @message = "Invalid/unknown plot_number/development"
  end

  # rubocop:disable Metrics/MethodLength
  def notify_and_redirect(new_resident)
    plot_residency = PlotResidency.find_by(resident_id: @resident.id, plot_id: @plot.id)

    if plot_residency && !plot_residency.deleted_at?
      yield I18n.t("residents.create.plot_residency_already_exists",
                   email: @resident.email, plot: @plot), 501
    elsif new_resident
      @resident.save!
      plot_residency_and_invitation(plot_residency)
      Mailchimp::MarketingMailService.call(@resident, @plot, activation_status)
      yield I18n.t("residents.create.resident_added",
                   name: @resident.full_name,
                   plot_number: @plot.number,
                   development: @params[:development],
                   email: @params[:email]), 201
    else
      plot_residency_and_invitation(plot_residency)
      yield I18n.t("residents.create.existing_resident_added",
                   name: @resident.full_name,
                   plot_number: @plot.number,
                   development: @params[:development]), 201
    end
  end
  # rubocop:enable Metrics/MethodLength

  def plot_residency_and_invitation(plot_residency)
    # Plot residency created by admin is always a homeowner
    if plot_residency.nil?
      plot_residency = PlotResidency.create!(resident_id: @resident.id, plot_id: @plot.id,
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
                                   RequestStore.store[:current_user], @plot.developer.to_s)
  end

  def activation_status
    if @resident.invitation_accepted?
      Rails.configuration.mailchimp[:activated]
    else
      Rails.configuration.mailchimp[:unactivated]
    end
  end
end
