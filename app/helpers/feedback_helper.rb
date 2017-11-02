# frozen_string_literal: true

module FeedbackHelper
  def data_for_feedback(email)
    {
      cancel: t("feedback.cancel"),
      title: t("feedback.title"),
      submit: t("feedback.submit"),
      option1: t("feedback.option1"),
      option2: t("feedback.option2"),
      option3: t("feedback.option3"),
      comments: t("feedback.comments"),
      placeholder: t("feedback.placeholder"),
      sendemail: t("feedback.send_email_addr"),
      emailaddr: email,
      leaveblank: t("feedback.leave_blank")
    }
  end
end
