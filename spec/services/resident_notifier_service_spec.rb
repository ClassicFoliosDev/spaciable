# frozen_string_literal: true
require "rails_helper"
require "sucker_punch/testing/inline"

RSpec.describe ResidentNotifierService do
  let(:current_user) { create(:developer_admin) }
  let(:developer_with_residents) { create(:developer, :with_residents) }
  let(:notification) { create(:notification, send_to: developer_with_residents) }
  let(:deliveries) { ActionMailer::Base.deliveries }

  around(:each) do |example|
    ActionMailer::Base.deliveries.clear
    example.call
    ActionMailer::Base.deliveries.clear
  end

  subject { described_class.new(notification) }

  describe "#notify_residents" do
    describe "email notification body" do
      let(:html_messages_sent) { deliveries.map(&:html_part).map(&:to_s) }
      let(:text_messages_sent) { deliveries.map(&:text_part).map(&:to_s) }

      it "should include the notification message" do
        content = notification.message

        subject.notify_residents
        raise "no messages sent" unless deliveries.count > 0

        expect(html_messages_sent).to all include(content)
        expect(text_messages_sent).to all include(content)
      end

      it "should include a link to login" do
        login_url = "http://localhost/"

        subject.notify_residents

        expect(html_messages_sent).to all include(login_url)
        expect(text_messages_sent).to all include(login_url)
      end
    end

    describe "email notification to field" do
      it "should send the notification to the residents email" do
        subject.notify_residents

        recipient_emails = deliveries.map(&:to)
        resident_emails = developer_with_residents.residents.pluck(:email).map { |email| [email] }

        expect(recipient_emails).to match_array(resident_emails)
      end
    end

    describe "resident notifications" do
      it "should create resident notifications for each resident" do
        residents = developer_with_residents.residents
        number_of_residents = residents.count

        expect do
          subject.notify_residents
        end.to change(ResidentNotification, :count).by(number_of_residents)

        expect(residents.map(&:homeowner_notifications)).to all eq([notification])
      end

      it "should record the sent_at times on the notification" do
        subject.notify_residents

        expect(notification.reload.sent_at).not_to be_nil
      end
    end

    context "send_to_all" do
      it "should create notifications for ALL residents" do
        create_list(:plot, 1, :with_resident)
        create_list(:plot, 2, :with_resident, development: create(:division_development))

        all_residents = User.homeowner
        cf_admin = create(:cf_admin)
        notification = create(:notification, sender: cf_admin, send_to: nil, send_to_all: true)

        notified_residents = described_class.new(notification).notify_residents

        expect(notified_residents).to match_array(all_residents)
      end
    end

    context "send_to Developer" do
      it "should create notifications for all developer residents" do
        developer_residents = developer_with_residents.residents

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(developer_residents)
      end

      context "with developer phase plots" do
        let(:developer_with_phase_residents) { create(:developer, :with_phase_residents) }
        let(:notification) { create(:notification, send_to: developer_with_phase_residents) }

        it "should create notifications for all developer phase residents" do
          residents = developer_with_phase_residents.residents
          raise "no residents" if residents.empty?

          notified_residents = subject.notify_residents

          expect(notified_residents).to match_array(residents)
        end
      end
    end

    context "send_to Division" do
      let(:division_with_residents) { create(:division, :with_residents) }
      let(:notification) { create(:notification, send_to: division_with_residents) }

      it "should create notifications for all division residents" do
        division_residents = division_with_residents.residents
        raise "no residents" if division_residents.empty?

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(division_residents)
      end

      context "with division phase plots" do
        let(:division_with_phase_residents) { create(:division, :with_phase_residents) }
        let(:notification) { create(:notification, send_to: division_with_phase_residents) }

        it "should create notifications for all division phase residents" do
          residents = division_with_phase_residents.residents
          raise "no residents" if residents.empty?

          notified_residents = subject.notify_residents

          expect(notified_residents).to match_array(residents)
        end
      end
    end

    context "send_to Development" do
      let(:development_with_residents) { create(:development, :with_residents) }
      let(:notification) { create(:notification, send_to: development_with_residents) }

      it "should create notifications for all development residents" do
        development_residents = development_with_residents.residents
        raise "no residents" if development_residents.empty?

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(development_residents)
      end
    end

    context "send_to Phase" do
      let(:phase_with_residents) { create(:phase, :with_residents) }
      let(:notification) { create(:notification, send_to: phase_with_residents) }

      it "should create notifications for all phase residents" do
        phase_residents = phase_with_residents.residents
        raise "no residents" if phase_residents.empty?

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(phase_residents)
      end
    end
  end
end
