# frozen_string_literal: true

class Setting < ApplicationRecord
  mount_uploader :cookie_policy, DocumentUploader
  mount_uploader :privacy_policy, DocumentUploader
  mount_uploader :help, DocumentUploader

  def set_filenames
    self.help_short_name = help.filename if help&.filename&.present?
    self.cookie_short_name = cookie_policy.filename if cookie_policy&.filename&.present?
    self.privacy_short_name = privacy_policy.filename if privacy_policy&.filename&.present?
    save!
  end
end
