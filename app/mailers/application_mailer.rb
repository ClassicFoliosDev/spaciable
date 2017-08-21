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
    @email = email unless email.blank?

    mail to: "feedback@hoozzi.com", subject: I18n.t("feedback.email_subject")
  end
end
