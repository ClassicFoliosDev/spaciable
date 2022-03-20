# frozen_string_literal: true

class UserPreference < ApplicationRecord
  belongs_to :user

  enum preference: %i[
    show_build_progress_dialog
    show_edit_build_progress_dialog
    show_video_restriction_dialog
    show_phase_calendar_restriction_dialog
    show_plot_calendar_restriction_dialog
    show_phase_document_restriction_dialog
    show_document_restriction_dialog
    show_build_progress_restriction_dialog
    show_custom_tile_restriction_dialog
    show_developer_csv_restriction_dialog
    show_faq_restriction_dialog
    show_plot_template_dialog
    show_free_plots_rooms_dialog
    show_finishes_info_dialog
    show_appliances_info_dialog
    show_dashboad_info_dialog
    show_stuck_with_specs_dialog
    show_spotlight_restriction_dialog
  ]
end
