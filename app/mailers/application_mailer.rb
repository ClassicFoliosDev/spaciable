# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@hoozzi.com"
  layout "email"

  def feedback(comments, option, email)
    @title = I18n.t("feedback.email_title")
    @option_title = I18n.t("feedback.option_title")
    @comment_title = I18n.t("feedback.comment_title")
    @email_title = t("feedback.email_addr_title")

    @comments = I18n.t("feedback.not_sent")
    @comments = comments unless comments.empty?

    @option = I18n.t("feedback.not_sent")
    @option = I18n.t("feedback.#{option}") unless option.empty?

    @email = I18n.t("feedback.not_sent")
    @email = email if email.present?

    mail to: "feedback@hoozzi.com", subject: I18n.t("feedback.email_subject")
  end

  def request_services(resident, old_service_names, plots)
    @title = I18n.t("application_mailer.request_services.title", name: resident.to_s)

    @resident = resident
    @new_services = resident.services.map(&:name)
    @old_services = old_service_names
    @plots = plots

    mail to: "services@hoozzi.com", subject: @title
  end
end
