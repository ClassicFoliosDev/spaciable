# frozen_string_literal: true

class CcEmail < ApplicationRecord
  belongs_to :user

  enum email_type: [
    :receive_invitation_emails,
    :receive_faq_emails,
    :receive_release_emails,
    :snag_notifications
  ]
end
