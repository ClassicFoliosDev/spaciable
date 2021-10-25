# frozen_string_literal: true

class UserPreference < ApplicationRecord
  belongs_to :user

  enum preference: %i[
    show_build_progress_dialog
    show_edit_build_progress_dialog
    show_video_restriction_dialog
  ]
end
