# frozen_string_literal: true

module AhoyEventEnum
  extend ActiveSupport::Concern

  ACCEPT_INVITATION = :homeowner_accept_invite
  LOG_IN = :homeowner_log_in
  SNAGS_CREATED = :snags_created
  SNAGGING_VIEWED = :snagging_viewed
  SNAGS_VIEWED = :snags_viewed
  SNAGS_RESOLVED = :snags_resolved
  SNAGS_REJECTED = :snags_rejected
  BC_FIND_OUT_MORE = :bc_find_out_more
  BC_GIVE_ME_ACCESS = :bc_give_me_access
  ROOT = :root
  TASK_VIEWED = :task_viewed

  included do
    enum ahoy_event_name: %i[
      homeowner_sign_in
      view_main_menu
      view_my_home view_contacts
      view_account view_messages
      refer_a_friend
      view_home_tour view_rooms
      view_appliances
      view_home_designer
      view_area_guide
      view_conveyancing
      view_calendar
      view_buyers_club
      view_your_journey view_your_content_proforma
      view_library
      view_how_to view_issues
      view_snagging view_FAQs view_FAQs_feedback
    ]
  end
end
