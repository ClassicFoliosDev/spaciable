# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResidentNotifierService do
  let(:current_user) { create(:developer_admin) }
  let(:developer_with_residents) { create(:developer, :with_activated_residents) }
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
        developer_name = developer_with_residents.company_name.parameterize_amp
        development_name = developer_with_residents.developments.first.name.parameterize_amp
        login_url = "http://localhost/#{developer_name}/#{development_name}"

        subject.notify_residents

        expect(html_messages_sent).to all include(login_url)
        expect(text_messages_sent).to all include(login_url)
      end

      it "should update the resident_notifications" do
        subject.notify_residents
        expect(notification.resident_notifications.length).to eq(3)
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
        create_list(:plot, 1, :with_activated_resident)
        create_list(:plot, 2, :with_activated_resident, development: create(:division_development))

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

      it "should update the resident_notifications" do
        subject.notify_residents
        expect(notification.resident_notifications.length).to eq(3)
      end

      context "with developer phase plots" do
        let(:developer_with_phase_residents) { create(:developer, :with_activated_phase_residents, plots_count: 5) }
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
            plot_numbers = []
            send_to_residents.each do | resident |
              resident.plots.each do | plot |
                plot_numbers << plot.number.to_i
              end
            end

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
      let(:division_with_residents) { create(:division, :with_activated_phase_residents, plots_count: 5) }
      let(:notification) { create(:notification, send_to: division_with_residents) }

      it "should create notifications for all division residents" do
        division_residents = division_with_residents.residents
        raise "no residents" if division_residents.empty?

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(division_residents)
      end

      it "should update the resident_notifications" do
        subject.notify_residents
        expect(notification.resident_notifications.length).to eq(5)
      end

      context "with division phase plots" do
        let(:division_with_phase_residents) { create(:division, :with_activated_phase_residents) }
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
          plot_numbers = []
          send_to_residents.each do | resident |
            resident.plots.each do | plot |
              plot_numbers << plot.number.to_i
            end
          end

          notification = create(:notification,
                                send_to: division_with_residents,
                                range_from: plot_numbers.min,
                                range_to: plot_numbers.max)

          notified_residents = described_class.new(notification).notify_residents

          expect(notification.resident_notifications.length).to eq(3)
          expect(notified_residents).to match_array(send_to_residents)
        end
      end
    end

    context "send_to Development" do
      let(:development_with_activated_residents) { create(:development, :with_activated_residents, plots_count: 5) }
      let(:notification) { create(:notification, send_to: development_with_activated_residents) }

      it "should create notifications for all development residents" do
        development_residents = development_with_activated_residents.residents
        raise "no residents" if development_residents.empty?

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(development_residents)
      end

      context "with a range of plots selected" do
        it "should only send notifications to the selected plot range residents" do
          residents = development_with_activated_residents.residents
          send_to_residents = residents.take(3)
          plot_numbers = []
          send_to_residents.each do | resident |
            resident.plots.each do | plot |
              plot_numbers << plot.number.to_i
            end
          end

          notification = create(:notification,
                                send_to: development_with_activated_residents,
                                range_from: plot_numbers.min,
                                range_to: plot_numbers.max)

          notified_residents = described_class.new(notification).notify_residents

          expect(notified_residents).to match_array(send_to_residents)
        end
      end
    end

    context "send_to Phase" do
      let(:phase_with_activated_residents) { create(:phase, :with_activated_residents) }
      let(:notification) { create(:notification, send_to: phase_with_activated_residents) }

      it "should create notifications for all phase residents" do
        phase_residents = phase_with_activated_residents.residents
        raise "no residents" if phase_residents.empty?

        notified_residents = subject.notify_residents

        expect(notified_residents).to match_array(phase_residents)
      end
    end

    context "plots with residencies" do
      it "should not return any missing resident plot numbers" do
        development = create(:development)
        notification = create(:notification, send_to: development)
        plots = create_list(:plot, 3, :with_activated_resident, development: development)
        plot_numbers = []
        plots.each do | plot |
          plot_numbers << plot.number.to_i
        end

        service = described_class.new(notification)
        expect(service.all_missing_plots).not_to match_array(plot_numbers)
      end

      it "should send to plot numbers" do
        development = create(:development)
        create(:plot, :with_activated_resident, development: development, number: "5.1")
        create(:plot, :with_activated_resident, development: development, number: "5a")
        create(:plot, :with_activated_resident, development: development, number: "5")
        notification = create(:notification, send_to: development, list: "5, 5a, 5.1")

        notified_residents = described_class.new(notification).notify_residents

        expect(notified_residents.length).to eq(3)
        full_plot_numbers = []
        notified_residents.each do | resident |
          resident.plots.each do | plot |
            full_plot_numbers << plot.to_s
          end
        end
        expect(full_plot_numbers).to match_array(["Plot 5", "Plot 5a", "Plot 5.1"])
      end

      it "should not send to plots with no residents" do
        development = create(:development)
        create(:plot, development: development, number: "4")
        create(:plot, development: development, number: "5")
        notification = create(:notification, send_to: development, list: "4, 5")

        service = described_class.new(notification)
        notified_residents = service.notify_residents

        expect(notified_residents.length).to eq(0)
        expect(service.all_missing_plots.to_sentence).to eq("4 and 5")
      end
    end

    context "send to role" do
      let (:phase) { create(:phase) }
      let (:plot_with_tenant) { create(:plot, :with_activated_resident, phase: phase) }
      let (:tenant) { create(:resident, :activated) }
      let (:plot_residency) { create(:plot_residency, plot_id: plot_with_tenant.id, resident_id: tenant.id, role: :tenant) }
      let (:plot) { create(:plot, :with_activated_resident, phase: phase) }

      it "sends to homeowners" do
        plot_residency
        homeowner = plot_with_tenant.plot_residencies.find_by(role: 'homeowner').resident
        homeowner2 = plot.plot_residencies.find_by(role: 'homeowner').resident

        notification = create(:notification, send_to: phase, send_to_role: :homeowner)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 2
          expect(notified_residents).to include homeowner
          expect(notified_residents).to include homeowner2
          expect(missing_residents.length).to eq 0
        end
      end

      it "sends to tenants" do
        plot_residency
        homeowner = plot_with_tenant.plot_residencies.find_by(role: 'homeowner').resident
        homeowner2 = plot.plot_residencies.find_by(role: 'homeowner').resident

        notification = create(:notification, send_to: phase, send_to_role: :tenant)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 1
          expect(notified_residents).to include tenant
          expect(missing_residents.length).to eq 1
          expect(missing_residents).to include plot.number
       end
      end

      it "sends to both" do
        plot_residency
        homeowner = plot_with_tenant.plot_residencies.find_by(role: 'homeowner').resident
        homeowner2 = plot.plot_residencies.find_by(role: 'homeowner').resident

        notification = create(:notification, send_to: phase, send_to_role: :both)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 3
          expect(notified_residents).to include homeowner
          expect(notified_residents).to include homeowner2
          expect(notified_residents).to include tenant
          expect(missing_residents.length).to eq 0
        end
      end
    end

    context "tenant is a homeowner on another plot" do
      let (:development) { create(:development) }
      let (:phase) { create(:phase, development: development) }
      let (:homeowner) { create(:resident, :activated) }
      let (:plot_with_tenant) { create(:plot, phase: phase, number: "4") }
      let (:tenant) { create(:resident, :activated) }
      let (:plot_residency1) { create(:plot_residency, plot_id: plot_with_tenant.id, resident_id: homeowner.id, role: :homeowner) }
      let (:plot_residency2) { create(:plot_residency, plot_id: plot_with_tenant.id, resident_id: tenant.id, role: :tenant) }

      # These plot residents should not receive notifications
      let (:other_phase) { create(:phase, development: development) }
      let (:other_plot) { create(:plot, :with_activated_resident, phase: other_phase, number: "5") }
      # Roles are reversed here, the tenant is a homeowner on this (other) plot, and the homeowner is a tenant
      let (:plot_residency3) { create(:plot_residency, plot_id: other_plot.id, resident_id: tenant.id, role: :homeowner) }
      let (:plot_residency4) { create(:plot_residency, plot_id: other_plot.id, resident_id: homeowner.id, role: :tenant) }

      it "sends to plot_with_tenant homeowners only" do
        plot_residency1
        plot_residency2
        plot_residency3
        plot_residency4

        notification = create(:notification, send_to: development, list: plot_with_tenant.number, send_to_role: :homeowner)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 1
          expect(notified_residents).to include homeowner
          expect(missing_residents.length).to eq 0
        end
      end

      it "sends to plot_with_tenant tenants only" do
        plot_residency1
        plot_residency2
        plot_residency3
        plot_residency4

        notification = create(:notification, send_to: development, list: plot_with_tenant.number, send_to_role: :tenant)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 1
          expect(notified_residents).to include tenant
          expect(missing_residents.length).to eq 0
        end
      end

      it "sends to plot_with_tenant both" do
        plot_residency1
        plot_residency2
        plot_residency3
        plot_residency4

        notification = create(:notification, send_to: development, list: plot_with_tenant.number, send_to_role: :both)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 2
          expect(notified_residents).to include homeowner
          expect(notified_residents).to include tenant
          expect(missing_residents.length).to eq 0
        end
      end

      it "sends to phase homeowners only" do
        plot_residency1
        plot_residency2
        plot_residency3
        plot_residency4

        notification = create(:notification, send_to: phase, send_to_role: :homeowner)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 1
          expect(notified_residents).to include homeowner
          expect(missing_residents.length).to eq 0
        end
      end

      it "sends to phase tenants only" do
        plot_residency1
        plot_residency2
        plot_residency3
        plot_residency4

        notification = create(:notification, send_to: phase, send_to_role: :tenant)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 1
          expect(notified_residents).to include tenant
          expect(missing_residents.length).to eq 0
        end
      end

      it "sends to phase both" do
        plot_residency1
        plot_residency2
        plot_residency3
        plot_residency4

        notification = create(:notification, send_to: phase, send_to_role: :both)

        described_class.call(notification) do |notified_residents, missing_residents|
          expect(notified_residents.length).to eq 2
          expect(notified_residents).to include homeowner
          expect(notified_residents).to include tenant
          expect(missing_residents.length).to eq 0
        end
      end
    end
  end

  describe "#all_missing_plots" do
    context "for plots without residents" do
      it "should return the missing plot numbers" do
        development = create(:development)
        notification = create(:notification, send_to: development)
        plots = create_list(:plot, 3, development: development)
        plot_numbers = []
        plots.each do | plot |
          plot_numbers << plot.number
        end

        service = described_class.new(notification)

        expect(service.all_missing_plots.length).to eq(3)
        expect(service.all_missing_plots).to match_array(plot_numbers)
      end
    end

    context "for plots with multiple residents" do
      it "should send to all of the residents" do
        development = create(:development)
        create(:plot, :with_activated_resident, development: development, number: "4")
        plot = create(:plot, :with_activated_resident, development: development, number: "5")
        second_resident = create(:resident, :activated)
        create(:plot_residency, plot_id: plot.id, resident_id: second_resident.id, role: :homeowner)
        notification = create(:notification, send_to: development)

        service = described_class.new(notification)
        notified_residents = service.notify_residents

        all_residents = Resident.all
        expect(notified_residents.length).to eq 3
        expect(notified_residents).to match_array(all_residents)
      end
    end

    context "a list of plot numbers has been supplied" do
      it "should only send to matching numbers from a list" do
        development = create(:development)
        notification = create(:notification, send_to: development, list: "2,4,5")
        plots = []
        plots[0] = create(:plot, :with_activated_resident, development: development, number: "4")
        plots[1] = create(:plot, :with_activated_resident, development: development, number: "7")

        service = described_class.new(notification)
        notified_residents = service.notify_residents

        expect(service.all_missing_plots.count).to eq(2)
        expect(service.all_missing_plots.to_sentence).to eq("2 and 5")

        expect(notified_residents.count).to eq(1)
        expect(notified_residents[0]).to eq(plots[0].residents.first)
      end
    end

    context "decimal plot numbers have been supplied" do
      it "should not return missing decimal plot numbers" do
        development = create(:development)
        notification = create(:notification, send_to: development)
        plots = []
        plots[0] = create(:plot, :with_activated_resident, development: development, number: "5")
        plots[1] = create(:plot, development: development, number: "4")
        plots[2] = create(:plot, :with_activated_resident, development: development, number: "5.55")
        plots[3] = create(:plot, :with_activated_resident, development: development, number: "A6")
        plots[4] = create(:plot, development: development, number: "2.31")
        plots[5] = create(:plot, :with_activated_resident, development: development, number: "3.10")
        plots[5] = create(:plot, development: development, number: "5.200")
        plots[6] = create(:plot, :with_activated_resident, development: development, number: "5.2")
        plots[7] = create(:plot, development: development, number: "b8")

        service = described_class.new(notification)

        expect(service.all_missing_plots.count).to eq(4)
        expect(service.all_missing_plots.to_sentence).to eq("2.31, 4, 5.200, and b8")
      end

      it "should only send to matching numbers from a list" do
        development = create(:development)
        notification = create(:notification, send_to: development, list: "2.6,4a,4b,5.200")
        plots = []
        plots[0] = create(:plot, :with_activated_resident, development: development, number: "5.200")
        plots[0] = create(:plot, :with_activated_resident, development: development, number: "4b")
        plots[1] = create(:plot, development: development, number: "4a")

        service = described_class.new(notification)
        notified_residents = service.notify_residents

        expect(service.all_missing_plots.count).to eq(2)
        expect(service.all_missing_plots.to_sentence).to eq("2.6 and 4a")

        expect(notified_residents.count).to eq(2)
      end
    end

    context "send_to_all" do
      it "does not return the missing residents" do
        create_list(:plot, 5)
        create_list(:plot, 5, :with_activated_resident)
        notification = create(:notification, send_to_all: true, sender: create(:cf_admin), send_to_id: nil, send_to_type: nil)

        described_class.call(notification) do |residents, missing_residents|
          expect(residents).not_to be_empty
          expect(missing_residents).to be_empty
          expect(notification.resident_notifications.length).to eq(5)
        end
      end
    end

    context  "send to role with missing residents" do
      let (:phase) { create(:phase) }
      let (:plot_with_tenant) { create(:plot, :with_activated_resident, phase: phase) }
      let (:tenant) { create(:resident, :activated) }
      let (:plot_residency) { create(:plot_residency, plot_id: plot_with_tenant.id, resident_id: tenant.id, role: :tenant) }

      let (:plot) { create(:plot, :with_activated_resident, phase: phase) }
      let (:empty_plot) { create(:plot, phase: phase) }

      it "sends to plot homeowners" do
        plot_residency
        empty_plot
        homeowner = plot_with_tenant.plot_residencies.find_by(role: 'homeowner').resident
        homeowner2 = plot.plot_residencies.find_by(role: 'homeowner').resident

        notification = create(:notification, send_to: phase, send_to_role: :homeowner)

        described_class.call(notification) do |residents, missing_residents|
          expect(residents.length).to eq 2
          expect(residents).to include homeowner
          expect(residents).to include homeowner2
          expect(missing_residents.length).to eq 1
          expect(missing_residents).to include empty_plot.number
        end
      end

      it "sends to plot tenants" do
        plot_residency
        empty_plot
        homeowner = plot_with_tenant.plot_residencies.find_by(role: 'homeowner').resident
        homeowner2 = plot.plot_residencies.find_by(role: 'homeowner').resident

        notification = create(:notification, send_to: phase, send_to_role: :tenant)

        described_class.call(notification) do |residents, missing_residents|
          expect(residents.length).to eq 1
          expect(residents).to include tenant
          expect(missing_residents.length).to eq 2
          expect(missing_residents).to include plot.number
          expect(missing_residents).to include empty_plot.number
        end
      end

      it "sends to both" do
        plot_residency
        empty_plot
        homeowner = plot_with_tenant.plot_residencies.find_by(role: 'homeowner').resident
        homeowner2 = plot.plot_residencies.find_by(role: 'homeowner').resident

        notification = create(:notification, send_to: phase, send_to_role: :both)

        described_class.call(notification) do |residents, missing_residents|
          expect(residents.length).to eq 3
          expect(residents).to include homeowner
          expect(residents).to include homeowner2
          expect(residents).to include tenant
          expect(missing_residents.length).to eq 1
          expect(missing_residents).to include empty_plot.number
       end
      end
    end
  end
end
