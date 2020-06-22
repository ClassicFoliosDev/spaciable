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

  def faq_feedback(question)
    @question = question

     mail to: "feedback@spaciable.com", subject: I18n.t("feedback.email_subject")
  end
end
