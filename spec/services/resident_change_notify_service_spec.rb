# frozen_string_literal: true
require "rails_helper"

RSpec.describe ResidentChangeNotifyService do
  let(:developer_with_residents) { create(:developer, :with_residents) }

  context "cf admin" do
    let(:current_user) { create(:cf_admin) }
    it "creates a notification for subscribed homeowner" do
      ActionMailer::Base.deliveries.clear
      resident = developer_with_residents.residents.first
      resident.developer_email_updates = true
      resident.save!

      result = described_class.call(developer_with_residents, current_user, "Spec tests")
      expect(result).to eq 1

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq(1)

      expect(deliveries[0].subject).to eq(I18n.t("resident_notification_mailer.notify.update_subject"))
      expect(deliveries[0].to).to include(resident.email)

      ActionMailer::Base.deliveries.clear
    end
  end

  context "developer admin" do
    let(:current_user) { create(:developer_admin) }
    it "does not create a notification for unsubscribed homeowners" do
      ActionMailer::Base.deliveries.clear

      described_class.call(developer_with_residents, current_user, "Spec tests")

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq(0)

      ActionMailer::Base.deliveries.clear
    end

    it "creates a notification for subscribed homeowner" do
      ActionMailer::Base.deliveries.clear
      resident = developer_with_residents.residents.first
      resident.developer_email_updates = true
      resident.save!

      result = described_class.call(developer_with_residents, current_user, "Spec tests")
      expect(result).to eq 1

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq(1)

      expect(deliveries[0].subject).to eq(I18n.t("resident_notification_mailer.notify.update_subject"))
      expect(deliveries[0].to).to include(resident.email)

      ActionMailer::Base.deliveries.clear
    end
  end

  context "division admin" do
    let(:current_user) { create(:division_admin) }
    let(:division_with_residents) { create(:division, :with_residents) }

    it "creates a notification for subscribed homeowner" do
      ActionMailer::Base.deliveries.clear
      resident = division_with_residents.residents.first
      resident.developer_email_updates = true
      resident.save!

      result = described_class.call(division_with_residents, current_user, "Spec tests")
      expect(result).to eq 1

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq(1)

      expect(deliveries[0].subject).to eq(I18n.t("resident_notification_mailer.notify.update_subject"))
      expect(deliveries[0].to).to include(resident.email)

      ActionMailer::Base.deliveries.clear
    end
  end

  context "development admin" do
    it "creates a notification for subscribed homeowner" do
      development = developer_with_residents.developments.first
      current_user = create(:development_admin, permission_level: development)

      ActionMailer::Base.deliveries.clear
      resident = developer_with_residents.residents.first
      resident.developer_email_updates = true
      resident.save!

      result = described_class.call(development, current_user, "Spec tests")
      expect(result).to eq 1

      deliveries = ActionMailer::Base.deliveries
      expect(deliveries.length).to eq(1)

      expect(deliveries[0].subject).to eq(I18n.t("resident_notification_mailer.notify.update_subject"))
      expect(deliveries[0].to).to include(resident.email)

      ActionMailer::Base.deliveries.clear
    end
  end
end
