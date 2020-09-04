# frozen_string_literal: true

module AhoyEventEnum
  extend ActiveSupport::Concern

  ACCEPT_INVITATION = :homeowner_accept_invite
  LOG_IN = :homeowner_log_in
  SNAGS_CREATED = :snags_created
  SNAGS_RESOLVED = :snags_resolved
  SNAGS_REJECTED = :snags_rejected
  BC_FIND_OUT_MORE = :bc_find_out_more
  BC_GIVE_ME_ACCESS = :bc_give_me_access

  included do
    enum ahoy_event_name: %i[
      view_my_home view_contacts
      view_account view_messages
      refer_a_friend view_main_menu
      view_home_tour view_rooms
      view_appliances view_library
      view_how_to view_home_designer
      view_services view_area_guide
      view_buyers_club
      view_your_journey
      view_FAQs view_FAQs_feedback
      view_snagging
      view_issues homeowner_sign_in
    ]
  end
end
