# frozen_string_literal: true

class InvitationSummaryMailer < ApplicationMailer
  default from: "feedback@spaciable.com"

  def resident_summary(user, residencies)
    @permission_level = user.permission_level # admin permission level
    @invitations = residencies.size # invitations sent (residencies count)
    # activations (check each resident status - call resident count)
    puts "####################################################"
    puts "#{Resident.where(id: residencies.each { |r| r.resident_id } ) }"
    #
  end

  def resident_count(residencies)
    # find each resident from the resident id on the residency
    residencies.each do |r|

    end
  end
end
