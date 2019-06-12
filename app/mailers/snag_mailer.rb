# frozen_string_literal: true

class SnagMailer < ApplicationMailer
  default from: "no-reply@hoozzi.com"

  def snag_to_admins(snag, status)
    @snag_title = snag.title
    snag_details(snag)
    create_emails(snag)
    send_notification(t("snag_mailer.#{status}"), status)
  end

  def snag_comment_to_admins(snag_comment)
    @snag_title = snag_comment.snag_title
    @commenter_name = snag_comment.commenter_name
    snag_details(snag_comment.snag)
    create_emails(snag_comment.snag)
    send_notification(t("snag_mailer.new_snag_comment",
                        commenter_name: @commenter_name))
  end

  def response_resolved_status(snag, status)
    @snag_title = snag.title
    snag_details(snag)
    create_emails(snag)
    send_notification(t("snag_mailer.notify_rejection", status: status), status)
  end

  private

  # Gather the plot details from the snag
  def snag_details(snag)
    @snag = snag
    @plot = snag.plot
  end

  # Create the array of emails and names
  def create_emails(snag)
    @emails = []
    plot = snag.plot
    @phase = plot.phase
    @phase.snag_users.each do |u|
      @emails << u[:email]
    end
  end

  def send_notification(subject, status = nil)
    @status = status
    return if @emails.empty?
    mail to: @emails, subject: subject
  end
end
