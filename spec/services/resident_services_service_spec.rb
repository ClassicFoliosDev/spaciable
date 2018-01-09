# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResidentServicesService do
  let(:resident) { create(:resident) }
  let(:developer) { create(:developer, enable_services: true) }
  let(:development) { create(:development, developer_id: developer.id) }
  let(:plot) { create(:plot, development_id: development.id) }
  let(:plot_resident) { create(:plot_residency, plot_id: plot.id, resident_id: resident.id) }
  let(:service1) {create(:service)}
  let(:service2) {create(:service)}
  let(:service3) {create(:service)}
  let(:service4) {create(:service)}

  context "when a resident selects services" do
    it "creates an email notification" do
      ActionMailer::Base.deliveries.clear

      plot_resident
      service_ids = [service1, service2].pluck(:id)
      service_count = described_class.call(resident, service_ids, false, plot)
      expect(service_count).to eq 2

      services_email = ActionMailer::Base.deliveries.last

      title = I18n.t("application_mailer.request_services.title", name: resident.to_s)
      expect(services_email.subject).to eq title
      expect(services_email.to).to include "services@hoozzi.com"

      expect(services_email.parts.first.body).to include I18n.t("application_mailer.request_services.subscribed")
      expect(services_email.parts.first.body).to include service1.name
      expect(services_email.parts.first.body).to include service2.name
      expect(services_email.parts.first.body).not_to include I18n.t("application_mailer.request_services.unsubscribed")

      ActionMailer::Base.deliveries.clear
    end
  end

  context "when a resident deselects services" do
    it "creates an email notification" do
      ActionMailer::Base.deliveries.clear

      ResidentService.create(resident_id: resident.id, service_id: service1.id)
      ResidentService.create(resident_id: resident.id, service_id: service2.id)
      ResidentService.create(resident_id: resident.id, service_id: service3.id)

      plot_resident
      service_ids = [service3, service4].pluck(:id)
      service_count = described_class.call(resident, service_ids, true, plot)
      expect(service_count).to eq 2

      services_email = ActionMailer::Base.deliveries.last

      title = I18n.t("application_mailer.request_services.title", name: resident.to_s)
      expect(services_email.subject).to eq title
      expect(services_email.to).to include "services@hoozzi.com"

      email_sections = services_email.parts.first.body.to_s.split(I18n.t("application_mailer.request_services.unsubscribed"))

      expect(email_sections[0]).to include I18n.t("application_mailer.request_services.subscribed")
      expect(email_sections[0]).to include service3.name
      expect(email_sections[0]).to include service4.name
      expect(email_sections[0]).not_to include service1.name
      expect(email_sections[0]).not_to include service2.name

      expect(email_sections[1]).to include service1.name
      expect(email_sections[1]).to include service2.name
      expect(email_sections[1]).not_to include service3.name
      expect(email_sections[1]).not_to include service4.name

      ActionMailer::Base.deliveries.clear
    end
  end
end
