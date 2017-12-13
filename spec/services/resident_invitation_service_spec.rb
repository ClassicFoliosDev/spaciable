# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResidentInvitationService do
  let(:current_user) { create(:developer_admin) }
  let(:developer_with_residents) { create(:developer, :with_phase_residents) }

  context "with a valid resident" do
    it "creates the reminders" do
      ActionMailer::Base.deliveries.clear
      resident = developer_with_residents.residents.first

      described_class.call(resident.plot_residencies.first, current_user)

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq(4)

      expect(deliveries[0].subject).to eq(I18n.t("devise.mailer.invitation_instructions.subject"))
      expect(deliveries[0].to).to include(resident.email)
      expect(deliveries[1].subject).to eq(I18n.t("reminder_title", ordinal: "First"))
      expect(deliveries[2].subject).to eq(I18n.t("reminder_title", ordinal: "Second"))
      expect(deliveries[3].subject).to eq(I18n.t("last_reminder_title", ordinal: "Third"))
      expect(deliveries[3].to).to include(resident.email)

      ActionMailer::Base.deliveries.clear
    end
  end

  context "with a resident who has already accepted an invitation" do
    it "does not create a new token" do
      resident = developer_with_residents.residents.first

      described_class.call(resident.plot_residencies.first, current_user)

      resident.accept_invitation!
      resident.update_attribute(:invitation_accepted_at, Time.zone.now)

      ActionMailer::Base.deliveries.clear

      phase = developer_with_residents.developments.first.phases.first
      new_plot = create(:plot, phase_id: phase.id)
      new_plot_residency = create(:plot_residency, plot_id: new_plot.id, resident_id: resident.id)

      result = described_class.call(new_plot_residency, current_user)
      expect(result.class).to eq NewPlotJob

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq 1

      expect(deliveries.first.subject).to eq(I18n.t("new_plot_title"))
    end
  end

  context "with a resident who has not accepted the first invitation" do
    it "creates a new token and sends new invitations" do
      resident = developer_with_residents.residents.first

      described_class.call(resident.plot_residencies.first, current_user)

      ActionMailer::Base.deliveries.clear

      phase = developer_with_residents.developments.first.phases.first
      new_plot = create(:plot, phase_id: phase.id)
      new_plot_residency = create(:plot_residency, plot_id: new_plot.id, resident_id: resident.id)

      described_class.call(new_plot_residency, current_user)

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq(4)

      expect(deliveries[0].subject).to eq(I18n.t("devise.mailer.invitation_instructions.subject"))
      expect(deliveries[0].to).to include(resident.email)
    end
  end
end

