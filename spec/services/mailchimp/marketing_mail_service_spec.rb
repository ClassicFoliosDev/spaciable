# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mailchimp::MarketingMailService do
  let(:developer) { create(:developer) }
  let(:current_user) { create(:developer_admin, developer: developer) }
  let(:development) { create(:development, developer: developer) }
  let(:plot) { create(:plot, development: development) }
  let(:resident) { create(:resident) }
  let(:plot_resident) { create(:plot_residency, resident: resident, plot: plot) }

  context "updating user status" do
    it "builds the merge fields for status only" do
      merge_fields = described_class.build_merge_fields(Rails.configuration.mailchimp[:activated], nil, nil)

      expect(merge_fields[:HOOZSTATUS]).to eq(Rails.configuration.mailchimp[:activated])
      expect(merge_fields.length).to eq 1
    end
  end

  context "adding a user to a plot" do
    it "builds the merge fields for plot and resident" do
      merge_fields = described_class.build_merge_fields(Rails.configuration.mailchimp[:unactivated], resident, plot_resident)

      expect(merge_fields[:HOOZSTATUS]).to eq(Rails.configuration.mailchimp[:unactivated])
      expect(merge_fields[:FNAME]).to eq(resident.first_name)
      expect(merge_fields[:LNAME]).to eq(resident.last_name)
      expect(merge_fields[:CDATE]).to eq(plot_resident.completion_date.to_s)
      expect(merge_fields[:DEVT]).to eq(development.to_s)
      expect(merge_fields[:TITLE]).to eq(resident.title)
      expect(merge_fields[:POSTAL]).to eq(plot.postal_name.to_s)
      expect(merge_fields[:BLDG]).to eq(plot.building_name.to_s)
      expect(merge_fields[:ROAD]).to eq(plot.road_name)
      expect(merge_fields[:CITY]).to eq(plot.city)
      expect(merge_fields[:COUNTY]).to eq(plot.county.to_s)
      expect(merge_fields[:ZIP]).to eq(plot.postcode)
      expect(merge_fields[:PHASE]).to eq(plot.phase.to_s)
      expect(merge_fields[:UNIT_TYPE]).to eq(plot.unit_type.to_s)

      expect(merge_fields.length).to eq 14
    end
  end

  context "updating an existing user" do
    it "builds the merge fields for resident only" do
      merge_fields = described_class.build_merge_fields(Rails.configuration.mailchimp[:unactivated], resident, nil)

      expect(merge_fields[:HOOZSTATUS]).to eq(Rails.configuration.mailchimp[:unactivated])
      expect(merge_fields[:FNAME]).to eq(resident.first_name)
      expect(merge_fields[:LNAME]).to eq(resident.last_name)
      expect(merge_fields[:TITLE]).to eq(resident.title)
      expect(merge_fields.length).to eq 4
    end
  end
end
