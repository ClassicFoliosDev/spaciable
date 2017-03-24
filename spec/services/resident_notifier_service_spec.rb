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

        expect(residents.map(&:notifications)).to all eq([notification])
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

        all_residents = Resident.all
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
        let(:developer_with_phase_residents) { create(:developer, :with_phase_residents, plots_count: 5) }
        let(:notification) { create(:notification, send_to: developer_with_phase_residents) }

        it "should create notifications for all developer phase residents" do
          residents = developer_with_phase_residents.residents
          raise "no residents" if residents.empty?

          notified_residents = subject.notify_residents

          expect(notified_residents).to match_array(residents)
        end

        context "with a range of plots selected" do
          it "should only send notifications to the selected plot range residents" do
            residents = developer_with_phase_residents.residents
            send_to_residents = residents.take(3)
            plot_numbers = send_to_residents.map(&:plot).map(&:number)

            notification = create(:notification,
                                  send_to: developer_with_phase_residents,
                                  range_from: plot_numbers.min,
                                  range_to: plot_numbers.max)

            notified_residents = described_class.new(notification).notify_residents

            expect(notified_residents).to match_array(send_to_residents)
          end
        end
      end
    end

    context "send_to Division" do
      let(:division_with_residents) { create(:division, :with_residents, plots_count: 5) }
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

      context "with a range of plots selected" do
        it "should only send notifications to the selected plot range residents" do
          residents = division_with_residents.residents
          send_to_residents = residents.take(3)
          plot_numbers = send_to_residents.map(&:plot).map(&:number)

          notification = create(:notification,
                                send_to: division_with_residents,
                                range_from: plot_numbers.min,
                                range_to: plot_numbers.max)

          notified_residents = described_class.new(notification).notify_residents

          expect(notified_residents).to match_array(send_to_residents)
        end
      end
    end

    context "send_to Development" do
      let(:development_with_residents) { create(:development, :with_residents, plots_count: 5) }
      let(:notification) { create(:notification, send_to: development_with_residents) }

      it "should create notifications for all development residents" do
        development_residents = development_with_residents.residents
        raise "no residents" if development_residents.empty?

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(development_residents)
      end

      context "with a range of plots selected" do
        it "should only send notifications to the selected plot range residents" do
          residents = development_with_residents.residents
          send_to_residents = residents.take(3)
          plot_numbers = send_to_residents.map(&:plot).map(&:number)

          notification = create(:notification,
                                send_to: development_with_residents,
                                range_from: plot_numbers.min,
                                range_to: plot_numbers.max)

          notified_residents = described_class.new(notification).notify_residents

          expect(notified_residents).to match_array(send_to_residents)
        end
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

  describe "#missing_resident_plots" do
    context "for plots without residents" do
      it "should return the missing plot numbers" do
        development = create(:development)
        notification = create(:notification, send_to: development)
        plots = create_list(:plot, 3, development: development)
        plot_numbers = plots.map(&:number)

        service = described_class.new(notification)

        expect(service.missing_resident_plots).to match_array(plot_numbers)
      end
    end

    context "for plots with residencies" do
      it "should not return any missing resident plot numbers" do
        development = create(:development)
        notification = create(:notification, send_to: development)
        plots = create_list(:plot, 3, :with_resident, development: development)
        plot_numbers = plots.map(&:number).map(&:to_s)

        service = described_class.new(notification)

        expect(service.missing_resident_plots).not_to match_array(plot_numbers)
      end
    end

    context "a range of plot numbers has been supplied" do
      it "should only return the plot numbers without residents within the range" do
        development = create(:development)
        notification = create(:notification, send_to: development)
        plots_without_residents = create_list(:plot, 10, development: development)
        plot_numbers = plots_without_residents.take(5).map(&:number).sort.map(&:to_s)

        notification.range_from = plot_numbers.min
        notification.range_to = plot_numbers.max
        service = described_class.new(notification)

        expect(service.missing_resident_plots).to match_array(plot_numbers)
      end
    end

    context "decimal plot numbers have been supplied" do
      it "should not return missing decimal plot numbers" do
        development = create(:development)
        notification = create(:notification, send_to: development)
        plots = []
        plots[0] = create(:plot, :with_resident, development: development, number: "5")
        plots[1] = create(:plot, development: development, number: "4")
        plots[2] = create(:plot, :with_resident, development: development, number: "5.55")
        plots[3] = create(:plot, development: development, number: "2.31")
        plots[4] = create(:plot, :with_resident, development: development, number: "5.2")

        service = described_class.new(notification)

        expect(service.missing_resident_plots.count).to eq(2)

        expect(service.missing_resident_plots).to include(4)
        expect(service.missing_resident_plots).to include(2.31)
        expect(service.missing_resident_plots).not_to include(5)
        expect(service.missing_resident_plots).not_to include(5.55)
        expect(service.missing_resident_plots).not_to include(5.2)
      end
    end

    context "send_to_all" do
      it "does not return the missing residents" do
        create_list(:plot, 5)
        create_list(:plot, 5, :with_resident)
        notification = create(:notification, send_to_all: true, sender: create(:cf_admin), send_to_id: nil, send_to_type: nil)

        described_class.call(notification) do |residents, missing_residents|
          expect(residents).not_to be_empty
          expect(missing_residents).to be_empty
        end
      end
    end
  end
end
