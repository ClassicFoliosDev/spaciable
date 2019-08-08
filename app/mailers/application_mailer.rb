# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@spaciable.com"
  layout "email"

  def feedback(comments, option, email, details)
    @title = I18n.t("feedback.email_title")
    @option_title = I18n.t("feedback.option_title")
    @comment_title = I18n.t("feedback.comment_title")
    @details_title = t("feedback.details_title")

    @comments = I18n.t("feedback.not_sent")
    @comments = comments unless comments.empty?

    @option = I18n.t("feedback.not_sent")
    @option = I18n.t("feedback.#{option}") unless option.empty?

    @email = I18n.t("feedback.not_sent")
    @email = email if email.present?

    @details = details

    mail to: "feedback@spaciable.com", subject: I18n.t("feedback.email_subject")
  end

  def request_services(resident, new_service_names, plot)
    @title = I18n.t("application_mailer.request_services.title", name: resident.to_s)

    @resident = resident
    @new_services = new_service_names
    @plot = plot

    mail to: "services@spaciable.com", subject: @title
  end
end
