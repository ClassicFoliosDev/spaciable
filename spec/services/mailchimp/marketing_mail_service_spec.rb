# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mailchimp::MarketingMailService do
  let(:developer) { create(:developer) }
  let(:current_user) { create(:developer_admin, developer: developer) }
  let(:address) { create(:address) }
  let(:development) { create(:development, developer: developer, address: address) }
  let(:phase) { create(:phase, development: development) }
  let(:plot) { create(:plot, phase: phase) }
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
      merge_fields = described_class.build_merge_fields(Rails.configuration.mailchimp[:unactivated], resident, plot)

      expect(merge_fields[:HOOZSTATUS]).to eq(Rails.configuration.mailchimp[:unactivated])
      expect(merge_fields[:FNAME]).to eq(resident.first_name)
      expect(merge_fields[:LNAME]).to eq(resident.last_name)
      expect(merge_fields[:CDATE]).to eq(plot.completion_date.to_s)
      expect(merge_fields[:DEVT]).to eq(development.to_s)
      expect(merge_fields[:TITLE]).to eq(resident.title)
      expect(merge_fields[:POSTAL]).to eq(plot.postal_number.to_s)
      expect(merge_fields[:BLDG]).to eq(plot.building_name.to_s)
      expect(merge_fields[:ROAD]).to eq(plot.road_name.to_s)
      expect(merge_fields[:LOCL]).to eq(plot.locality.to_s)
      expect(merge_fields[:CITY]).to eq(plot.city.to_s)
      expect(merge_fields[:COUNTY]).to eq(plot.county.to_s)
      expect(merge_fields[:ZIP]).to eq(plot.postcode)
      expect(merge_fields[:PHASE]).to eq(plot.phase.to_s)
      expect(merge_fields[:PLOT]).to eq(plot.to_s)
      expect(merge_fields[:UNIT_TYPE]).to eq(plot.unit_type.to_s)
      expect(merge_fields[:DEVLPR_UPD]).to eq(Rails.configuration.mailchimp[:unsubscribed])
      expect(merge_fields[:HOOZ_UPD]).to eq(Rails.configuration.mailchimp[:unsubscribed])
      expect(merge_fields[:PHONE_UPD]).to eq(Rails.configuration.mailchimp[:unsubscribed])
      expect(merge_fields[:POST_UPD]).to eq(Rails.configuration.mailchimp[:unsubscribed])
      expect(merge_fields[:PHONE]).to eq(resident.phone_number)

      expect(merge_fields.length).to eq 21
    end
  end

  context "updating an existing user" do
    it "builds the merge fields for resident only" do
      resident.cf_email_updates = 1
      resident.post_updates = 1
      merge_fields = described_class.build_merge_fields(Rails.configuration.mailchimp[:unactivated], resident, nil)

      expect(resident.subscribed_status).to eq(Rails.configuration.mailchimp[:subscribed])

      expect(merge_fields[:HOOZSTATUS]).to eq(Rails.configuration.mailchimp[:unactivated])
      expect(merge_fields[:FNAME]).to eq(resident.first_name)
      expect(merge_fields[:LNAME]).to eq(resident.last_name)
      expect(merge_fields[:TITLE]).to eq(resident.title)
      expect(merge_fields[:DEVLPR_UPD]).to eq(Rails.configuration.mailchimp[:unsubscribed])
      expect(merge_fields[:HOOZ_UPD]).to eq(Rails.configuration.mailchimp[:subscribed])
      expect(merge_fields[:PHONE_UPD]).to eq(Rails.configuration.mailchimp[:unsubscribed])
      expect(merge_fields[:POST_UPD]).to eq(Rails.configuration.mailchimp[:subscribed])
      expect(merge_fields[:PHONE]).to eq(resident.phone_number)
      expect(merge_fields.length).to eq 9
    end
  end

  context "email hash" do
    it "returns the correct hash" do
      email = "lower_case@example.com"

      result =  described_class.md5_hashed_email(email)
      expect(result).to eq "4d3c3a254f7ed41d1f5d3786c81e815b"

      email = "CamelCase@example.com"

      result =  described_class.md5_hashed_email(email)
      expect(result).to eq "c312cc447cb95ed81b14654e3bce3511"
    end
  end
end
