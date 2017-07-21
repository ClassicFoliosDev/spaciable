# frozen_string_literal: true
require "rails_helper"

RSpec.describe ResidentInvitationService do
  let(:current_user) { create(:developer_admin) }
  let(:developer_with_residents) { create(:developer, :with_residents) }

  context "with a valid resident" do
    it "creates the reminders" do
      ActionMailer::Base.deliveries.clear
      resident = developer_with_residents.residents.first

      result = described_class.call(resident, current_user)
      expect(result.arguments[1]).to eq(I18n.t("last_reminder_title", ordinal: "Third"))

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
end
