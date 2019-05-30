# frozen_string_literal: true

class ChoiceMailer < ApplicationMailer
  default from: "no-reply@hoozzi.com"
  layout "email"

  def homeowner_choices_selected(plot, sender)
    @admins = plot.choice_admins ||
              { email:  plot&.choices_email_contact,
                first_name: "Sir/Madam" }

    # if there are no admins to receive the message - send to the cf admin
    @admins = User.where(role: "cf_admin") if @admins.empty?

    @plot = plot
    mail to: @admins.map(&:email).join(","),
         from: sender,
         subject: I18n.t("choices.admin.email_subject.selected", plot_name: @plot.number)
  end

  def homeowner_choices_rejected(plot, notification)
    @plot = plot
    @notification = notification.dup
    mail to: @plot.homeowners.map(&:email).join(","),
         subject: I18n.t("choices.homeowner.email_subject.rejected", plot_name: @plot.number)
  end

  def homeowner_choices_approved(plot)
    @plot = plot
    mail to: @plot.homeowners.map(&:email).join(","),
         subject: I18n.t("choices.homeowner.email_subject.approved", plot_name: @plot.number)
  end

  def admin_approved_choices(plot, sender)
    @plot = plot
    mail to: [plot&.choices_email_contact, sender],
         from: sender,
         subject: I18n.t("choices.admin.email_subject.selected", plot_name: @plot.number)
  end
end
