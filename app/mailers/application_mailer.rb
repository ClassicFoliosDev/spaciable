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

  def faq_feedback(data)
    @email = data[:email]
    @plot = Plot.find(data[:plot])
    @development = @plot.development
    @phase = @plot.phase
    @admin_emails = faq_feedback_emails(@plot)

    @question = data[:question]
    @response = data[:response].to_i
    @feedback = data[:feedback]

    mail to: @admin_emails,
         bcc: "feedback@spaciable.com",
         subject: I18n.t("feedback.email_subject")
  end

  def faq_feedback_emails(plot)
    users = User.where(receive_faq_emails: true)
                .where("(role = #{User.roles[:developer_admin]} AND " \
                       "permission_level_id = #{plot.developer_id}) " \
                       "OR (role = #{User.roles[:division_admin]} AND " \
                       "(permission_level_id = #{plot.division_id}) " \
                       "OR (role = #{User.roles[:development_admin]} " \
                       "AND permission_level_id = #{plot.development_id})")

    emails = []
    users.each { |user| emails << user.email }
    emails
  end
end
