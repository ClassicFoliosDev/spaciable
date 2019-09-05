# frozen_string_literal: true

class ChoiceMailer < ApplicationMailer
  default from: "no-reply@spaciable.com"
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
    @logo = email_logo_or_brand_logo
    @notification = notification.dup
    mail to: @plot.homeowners.map(&:email).join(","),
         subject: I18n.t("choices.homeowner.email_subject.rejected", plot_name: @plot.number)
  end

  def homeowner_choices_approved(plot)
    @plot = plot
    @logo = email_logo_or_brand_logo
    mail to: @plot.homeowners.map(&:email).join(","),
         subject: I18n.t("choices.homeowner.email_subject.approved", plot_name: @plot.number)
  end

  def admin_approved_choices(plot, sender)
    @plot = plot
    mail to: [plot&.choices_email_contact, sender],
         from: sender,
         subject: I18n.t("choices.admin.email_subject.selected", plot_name: @plot.number)
  end

  private

  def email_logo_or_brand_logo
    @plot&.branded_email_logo ? @plot.branded_email_logo : brand_logo_or_default_logo
  end

  def brand_logo_or_default_logo
    @plot&.branded_logo ? @plot.branded_logo : "Spaciable_full.svg"
  end
end
