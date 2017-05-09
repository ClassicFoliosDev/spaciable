# frozen_string_literal: true
module Residents
  class InvitationsController < Devise::InvitationsController
    layout "accept"

    def update
      super

      merge_fields = { HOOZSTATUS: "activated" }
      MailchimpJob.perform_later("91418e8697",
                                 current_resident.email,
                                 merge_fields)
    end
  end
end
