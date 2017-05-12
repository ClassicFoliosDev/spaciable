# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mailchimp::MarketingMailService do
  let(:developer) { create(:developer) }
  let(:current_user) { create(:developer_admin, developer: developer) }
  let(:development) { create(:development, developer: developer) }
  let(:plot) { create(:plot, development: development) }
  let(:resident) { create(:resident) }
  let(:plot_resident) { create(:plot_residency, resident: resident, plot: plot) }

  context "adding a user to a plot" do
    it "builds the merge fields" do
      merge_fields = described_class.build_merge_fields(Rails.configuration.mailchimp[:unactivated], plot_resident)

      expect(merge_fields[:HOOZSTATUS]).to eq(Rails.configuration.mailchimp[:unactivated])
      expect(merge_fields[:FNAME]).to eq(resident.first_name)
      expect(merge_fields[:LNAME]).to eq(resident.last_name)
      expect(merge_fields[:CDATE]).to eq(plot_resident.completion_date.to_s)
    end
  end
end
