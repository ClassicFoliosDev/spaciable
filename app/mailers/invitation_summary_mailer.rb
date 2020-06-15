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
        invitation_date: r.created_at.strftime("%d-%m-%Y"),
        plot: plot.number,
        dev_phase: [Development.find(plot.development_id).name, Phase.find(plot.phase_id).name].compact.join(", "),
        division: Division.find_by(id: plot.division_id)&.division_name
      }

      inactive << residency
    end

    inactive.sort_by! { |r| [ r[:development], r[:phase], r[:invitation_date] ] }

    @inactive_residencies = {}
    divisions = inactive.group_by { |r| r[:division] }

    divisions.each do |d, v|
      @inactive_residencies[d] = v.group_by { |r| r[:dev_phase] }
    end

    mail to: @user.email,
         subject: I18n.t("invitation_summary_mailer.resident_summary.subject")
  end
end
