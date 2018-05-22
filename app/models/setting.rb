# frozen_string_literal: true

class Setting < ApplicationRecord
  mount_uploader :cookie_policy, DocumentUploader
  mount_uploader :privacy_policy, DocumentUploader
  mount_uploader :help, DocumentUploader

  # rubocop:disable Metrics/AbcSize
  def set_filenames
    self.help_short_name = help.file.original_filename if help&.file&.original_filename&.present?
    if cookie_policy&.file&.original_filename&.present?
      self.cookie_short_name = cookie_policy.file.original_filename
    end
    if privacy_policy&.file&.original_filename&.present?
      self.privacy_short_name = privacy_policy.file.original_filename
    end
    save!
  end
  # rubocop:enable Metrics/AbcSize
end
