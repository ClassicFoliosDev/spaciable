# frozen_string_literal: true

class CcEmail < ApplicationRecord
  belongs_to :user

  enum email_type: %i[
    receive_invitation_emails
    receive_faq_emails
    receive_release_emails
    snag_notifications
  ]

  def self.emails_list(u_emails, type)
    users = []
    emails = []

    u_emails.each do |email|
      users << User.find_by(email: email)
    end

    return unless users
    users.each do |user|
      cc = CcEmail.find_by(user_id: user.id, email_type: type)
      emails << cc.email_list.split(", ") if cc
    end

    emails.flatten!
  end
end
