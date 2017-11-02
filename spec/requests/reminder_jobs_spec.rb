# frozen_string_literal: true

require "rails_helper"
include ActiveJob::TestHelper

RSpec.describe "Reminder jobs", type: :feature do
  let(:developer_with_residents) { create(:developer, :with_residents) }

  context "when there are jobs queued for a resident" do
    it "removes them from the queue" do
      resident = developer_with_residents.residents.first

      Sidekiq::Testing.disable! do
        scheduled_jobs = Sidekiq::ScheduledSet.new
        initial_jobs = scheduled_jobs.size

        InvitationReminderJob.set(wait: 3.minutes).perform_later(resident, "Spec testing", "abc")
        InvitationReminderJob.set(wait: 5.minutes).perform_later(resident, "Spec testing", "abc")
        InvitationReminderJob.set(wait: 7.minutes).perform_later(resident, "Spec testing", "abc")

        scheduled_jobs = Sidekiq::ScheduledSet.new
        expect(scheduled_jobs.size).to eq(initial_jobs + 3)

        JobManagementService.call(resident.id)

        scheduled_jobs = Sidekiq::ScheduledSet.new
        expect(scheduled_jobs.size).to eq(initial_jobs)
      end
    end

    context "when there are jobs queued for two residents" do
      it "only removes the one for the matching resident" do
        resident = developer_with_residents.residents.first
        resident2 = developer_with_residents.residents.last

        Sidekiq::Testing.disable! do
          scheduled_jobs = Sidekiq::ScheduledSet.new
          initial_jobs = scheduled_jobs.size

          InvitationReminderJob.set(wait: 3.minutes).perform_later(resident, "Spec testing", "abc")
          InvitationReminderJob.set(wait: 5.minutes).perform_later(resident2, "Spec testing", "abc")

          scheduled_jobs = Sidekiq::ScheduledSet.new
          expect(scheduled_jobs.size).to eq(initial_jobs + 2)

          JobManagementService.call(resident.id)

          scheduled_jobs = Sidekiq::ScheduledSet.new
          expect(scheduled_jobs.size).to eq(initial_jobs + 1)
        end
      end

      context "when there is a job queued and it has not been removed" do
        it "fires when the wait time expires" do
          resident = developer_with_residents.residents.first

          InvitationReminderJob.perform_later(resident, "Spec testing 1", "abc")

          deliveries = ActionMailer::Base.deliveries
          expect(deliveries.length).to eq(1)
        end
      end
    end
  end
end
