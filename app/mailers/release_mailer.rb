# frozen_string_literal: true

class ReleaseMailer < ApplicationMailer
  default from: "hello@spaciable.com", content_type: "multipart/alternative"

  def reservation_release_email(phase, updated_plots, params)
    create_globals(phase, updated_plots, params)
    send_mail(t("reservation_email.title"))
  end

  def completion_release_email(phase, updated_plots, params)
    create_globals(phase, updated_plots, params)
    calc_min_expiry_date(phase, updated_plots)
    send_mail(t("completion_email.title"))
  end

  private

  # Calculate the minimum expiry date.  This is the release date plus the minimum
  # validity + extended date of all the plots being updated
  def calc_min_expiry_date(phase, updated_plots)
    minmonths = Plot.where(phase_id: phase.id)
                    .where(number: updated_plots).pluck(:validity, :extended_access)
                    .map { |v, e|  v + e }
                    .min

    @expiry_date_s = (@release_date + minmonths.months).strftime("%d/%m/%y")
  end

  # create the globals to populate the email views
  def create_globals(phase, updated_plots, params)
    @phase = phase
    @plots = updated_plots
    @order_number = params[:order_number]
    @release_date = Date.parse(params[:release_date])
    @release_date_s = @release_date.strftime("%d/%m/%y")
    @send_to_admins = params[:send_to_admins]
    create_emails
  end

  # Create the arrays of emails and names
  def create_emails
    @emails = []
    @names = []
    if @send_to_admins == "true"
      @phase.release_users.each do |u|
        @emails << u[:email]
        @names << u[:first_name]
      end
    else
      @emails << "hello@spaciable.com"
      @names << "Spaciable Admin"
    end
  end

  # Send the mail
  def send_mail(subject)
    if @send_to_admins == "true"
      mail(to: @emails,
           subject: subject,
           cc: ["hello@spaciable.com, customerexperience@classicfolios.com",
                CcEmail.emails_list(@emails, :receive_release_emails)])
    else
      mail(to: @emails,
           subject: subject)
    end
  end
end
