# frozen_string_literal: true

class ResidentSnagMailer < ApplicationMailer
  default from: "no-reply@hoozzi.com"

  def snag_comment_email(snag_comment)
    get_comment_info(snag_comment)
    mailer_template(snag_comment)
    subject = t(".snag_comment_subject", commenter_name: @commenter_name)
    send_notification(subject) unless @emails.empty?
  end

  def snag_status_email(snag, current_user)
    @user = snag.user_name(current_user)
    get_snag_info(snag)
    mailer_template(snag)
    subject = t(".snag_status_subject")
    send_notification(subject) unless @emails.empty?
  end

  def all_snags_resolved_email(snag)
    get_snag_info(snag)
    mailer_template(snag)
    subject = t(".snags_resolved_subject")
    send_notification(subject) unless @emails.empty?
  end

  private

  def mailer_template(info)
    get_plot_info(info)
    create_emails(info)
    logo_configuration
  end

  def get_snag_info(snag)
    @snag_title = snag.title
    @tool_name = snag.snag_name
  end

  def get_comment_info(snag_comment)
    @snag_title = snag_comment.snag_title
    @commenter_name = snag_comment.commenter_name
    @tool_name = snag_comment.snag.development.snag_name
  end

  def get_plot_info(snag_info)
    @plot = snag_info.plot
    @development = @plot.development
    @plot_number = @plot.number
    get_address(@plot)
  end

  def get_address(plot)
    @prefix = plot.prefix
    @postal = plot.postal_number
    @building = plot.building_name
    @street = plot.road_name
    @address = [@prefix, @postal, @building, @street].compact.join(" ")
  end

  def create_emails(snag_info)
    @emails = []
    @plot = snag_info.plot
    @plot.residents.each do |r|
      @emails << r[:email] if r.plot_residency_homeowner?(@plot) && r.developer_email_updates?
    end
  end

  def logo_configuration
    @logo = @plot&.branded_email_logo ? @plot.branded_email_logo : brand_logo_or_default_logo
  end

  def brand_logo_or_default_logo
    @plot&.branded_logo ? @plot.branded_logo : "logo.png"
  end

  def send_notification(subject)
    mail to: @emails, subject: subject
  end
end
