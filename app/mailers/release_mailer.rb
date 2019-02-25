# frozen_string_literal: true

class ReleaseMailer < ApplicationMailer
  default from: "hello@hoozzi.com", content_type: "multipart/alternative"

  def reservation_release_email(phase, updated_plots, params)
    create_globals(phase, updated_plots, params)
    send_mail(t("reservation_email.title"))
  end

  def completion_release_email(phase, updated_plots, params)
    create_globals(phase, updated_plots, params)
    expiry_date = @release_date >> params[:validity].to_i >> params[:extended].to_i
    @expiry_date_s = expiry_date.strftime("%d/%m/%y")

    send_mail(t("completion_email.title"))
  end

  private

  # create the globals to populate the email views
  def create_globals(phase, updated_plots, params)
    @phase = phase
    @plots = updated_plots
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
      @emails << "hello@hoozzi.com"
      @names << "Hoozzi Admin"
    end
  end

  # Send the mail
  def send_mail(subject)
    attachments.inline["logo.png"] = File.read(Rails.root.join("app",
                                                               "assets",
                                                               "images",
                                                               "logo.png"))
    mail(to: @emails,
         subject: subject,
         cc: "hello@hoozzi.com, accountmanagement@classicfolios.com")
  end
end
