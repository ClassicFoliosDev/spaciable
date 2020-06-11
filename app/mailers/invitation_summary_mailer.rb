# frozen_string_literal: true

class InvitationSummaryMailer < ApplicationMailer
  default from: "feedback@spaciable.com"

  def resident_summary(user, residencies)
    # admin permission level
    # invitations sent (residencies count)
    # activations (check each resident status - call resident count)

    #
  end

  def resident_count(residencies)
    # find each resident from the resident id on the residency
  end
end
