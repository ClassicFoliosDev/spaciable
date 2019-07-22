# frozen_string_literal: true

module FeedbackHelper
  def data_for_feedback(user)
    if user.is_a?(Resident)
      feedback_data = {
        details: list_plots(user)
      }
    elsif user.is_a?(User)
      feedback_data = {
        details: user.permission_level.to_s
      }

    end
    feedback = feedback_data.merge(default_data(user))

    feedback
  end

  def default_data(user)
    {
      cancel: t("feedback.cancel"),
      title: t("feedback.title"),
      submit: t("feedback.submit"),
      option1: t("feedback.option1"),
      option2: t("feedback.option2"),
      option3: t("feedback.option3"),
      comments: t("feedback.comments"),
      placeholder: t("feedback.placeholder"),
      disclaimer: t("feedback.disclaimer"),
      emailaddr: user.email
    }
  end

  def list_plots(user)
    address_list = ""
    user.plots.each do |plot|
      address_list += [plot.number, (plot.phase_name if plot.phase),
                       (plot.development_name if plot.development)].compact.join(" ")
      address_list += tag("br")
    end
    address_list
  end
end
