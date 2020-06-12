# frozen_string_literal: true

class InvitationSummaryMailer < ApplicationMailer
  default from: "feedback@spaciable.com"

  def resident_summary(user, residencies)
    @user = user
    @invitations_count = residencies.size
    inactive = []

    residencies.each do |r|
      next unless Resident.find(r.resident_id).invitation_accepted_at == nil

      plot = Plot.find(r.plot_id)
      residency = {
        email: Resident.find(r.resident_id).email,
        invitation_date: r.created_at.strftime("%d %B"),
        plot: plot.number,
        phase: Phase.find(plot.phase_id).name,
        development: Development.find(plot.development_id).name,
        division: Division.find_by(id: plot.division_id)&.division_name
      }

      inactive << residency
    end

    @inactive_residencies = inactive

    divisions = inactive.group_by { |r| r[:division] }
#     developments = divisions.group_by { |div, arr| arr[:development] }

#     divisions.each { |d, v| puts "######################### #{v}" }
    @developments = divisions.each do |d, v|
      v.group_by { |r| r[:development] }
#       puts "################################ #{x}"
    end

#     puts "#################### #{developments}"

#     @inactive_residencies.sort_by! { |r| [ r[:development], r[:phase], r[:plot] ] }

    mail to: @user.email,
         subject: I18n.t("invitation_summary_mailer.resident_summary.subject")
  end
end
