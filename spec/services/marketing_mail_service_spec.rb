# frozen_string_literal: true
require "rails_helper"

RSpec.describe MarketingMailService do
  let(:developer) { create(:developer) }
  let(:current_user) { create(:developer_admin, developer: developer) }
  let(:development) { create(:development, developer: developer) }
  let(:plot) { create(:plot, development: development) }
  let(:resident) { create(:resident) }
  let(:plot_resident) { create(:plot_residency, resident: resident, plot: plot) }

  context "adding a user to a plot" do
    it "registers a new resident with the marketing mail service" do
      marketing_mail_job = described_class.call(plot_resident, "unactivated")

      # Argument 0 is the list id, argument 1 is the email, argument 2 is the merge parameters
      expect(marketing_mail_job.arguments[1]).to eq(resident.email)
      expect(marketing_mail_job.arguments[2][:HOOZSTATUS]).to eq("unactivated")
      expect(marketing_mail_job.arguments[2][:FNAME]).to eq(resident.first_name)
      expect(marketing_mail_job.arguments[2][:LNAME]).to eq(resident.last_name)
    end
  end
end
