# frozen_string_literal: true

require "rails_helper"
include ActiveJob::TestHelper

RSpec.describe "Reminder jobs", type: :feature do
  include ActiveSupport::Testing::TimeHelpers
  let(:developer_with_residents) { create(:developer, :with_residents) }

  context "when there are jobs queued for a resident and they are deleted" do
    it "removes them from the queue" do
      Delayed::Worker.delay_jobs = true
      resident = developer_with_residents.residents.first

      InvitationReminderJob.set(wait: 3.minutes).perform_later(resident, "Spec testing", "abc")
      InvitationReminderJob.set(wait: 5.minutes).perform_later(resident, "Spec testing", "abc")
      InvitationReminderJob.set(wait: 7.minutes).perform_later(resident, "Spec testing", "abc")

      scheduled_jobs = Delayed::Job.all
      expect(scheduled_jobs.count).to eq(3)

      JobManagementService.call(resident.id)

      scheduled_jobs = Delayed::Job.count
      expect(scheduled_jobs).to eq(0)

      Delayed::Worker.delay_jobs = false
      ActionMailer::Base.deliveries.clear
    end

    context "when there are jobs queued for two residents" do
      it "only removes the one for the matching resident" do
        Delayed::Worker.delay_jobs = true

        resident = developer_with_residents.residents.first
        resident2 = developer_with_residents.residents.last

        scheduled_jobs = Delayed::Job.all
        initial_jobs = scheduled_jobs.size

        InvitationReminderJob.set(wait: 3.minutes).perform_later(resident, "Spec testing", "abc")
        InvitationReminderJob.set(wait: 5.minutes).perform_later(resident2, "Spec testing", "abc")

        scheduled_jobs = Delayed::Job.all
        expect(scheduled_jobs.size).to eq(initial_jobs + 2)

        JobManagementService.call(resident.id)

        scheduled_jobs = Delayed::Job.all
        expect(scheduled_jobs.size).to eq(initial_jobs + 1)

        Delayed::Worker.delay_jobs = false
        ActionMailer::Base.deliveries.clear
      end
    end

    context "when there is a job queued and it has not been removed" do
      it "fires when the wait time expires" do
        ActionMailer::Base.deliveries.clear
        resident = developer_with_residents.residents.first

        InvitationReminderJob.set(wait: 2.seconds).perform_later(resident, "Spec testing", "abc")

        scheduled_jobs = Delayed::Job.all
        expect(scheduled_jobs.size).to eq(0)

        ActionMailer::Base.deliveries.clear
      end
    end
  end
end
