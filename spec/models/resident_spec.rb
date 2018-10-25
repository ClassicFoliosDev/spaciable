# frozen_string_literal: true

require "rails_helper"

RSpec.describe Resident do
  describe "#plot=" do
    context "without an existing plot residency" do
      it "should create a new plot residency to access the plot" do
        resident = create(:resident)
        plot = create(:plot)

        resident.plot = plot
        resident.save
        resident.reload

        expect(resident.plot_residencies).not_to be_empty
        expect(resident.plot_residencies.first.plot_id).to eq(plot.id)
        expect(resident.plot_residencies.first.resident_id).to eq(resident.id)
        expect(resident.plot_residencies.first.plot).to eq(plot)
      end
    end

    context "already with a plot_residencies.first" do
      it "should update an existing plot residency" do
        resident = create(:resident, :with_residency)

        new_plot = create(:plot)

        resident.update(plot: new_plot)
        resident.reload

        expect(resident.plot_residencies.first.plot_id).to eq(new_plot.id)
        expect(resident.plot_residencies.first.resident_id).to eq(resident.id)
        expect(resident.reload.plot_residencies.first.plot).to eq(new_plot)
      end
    end

    context "with valid phone number" do
      resident = described_class.new(email: "test@example.com",
                                     first_name: "Joe",
                                     last_name: "Bloggs",
                                     password: "passw0rd",
                                     phone_number: "07768 321456")
      it "should be a valid resident" do
        expect(resident).to be_valid
      end
    end

    context "with invalid contents" do
      resident = described_class.new(phone_number: "07768 32145")
      it "should not be a valid resident" do
        expect(resident).not_to be_valid

        required = " is required, and must not be blank."
        expect(resident.errors.messages[:email]).to include(required)
        expect(resident.errors.messages[:first_name]).to include(required)
        expect(resident.errors.messages[:last_name]).to include(required)
        expect(resident.errors.messages[:password]).to include(required)
        expect(resident.errors.messages[:phone_number]).to include("is invalid")
      end
    end
  end

  describe "#subscribed_status" do
    context "when not getting email updates" do
      it "should be unsubscribed" do
        resident = create(:resident)

        resident.cf_email_updates = false
        resident.developer_email_updates = false
        resident.save!

        expect(resident.subscribed_status).to eq("unsubscribed")
      end
    end

    context "when getting email updates" do
      it "should be subscribed" do
        resident = create(:resident)

        resident.cf_email_updates = true
        resident.developer_email_updates = false
        resident.save!

        expect(resident.subscribed_status).to eq("subscribed")
      end
    end

    context "when getting developer email updates" do
      it "should be subscribed" do
        resident = create(:resident)

        resident.cf_email_updates = false
        resident.developer_email_updates = true
        resident.save!

        expect(resident.subscribed_status).to eq("subscribed")
      end
    end

    context "when getting both email updates" do
      it "should be subscribed" do
        resident = create(:resident)

        resident.cf_email_updates = true
        resident.developer_email_updates = true

        expect(resident.subscribed_status).to eq("subscribed")
      end
    end

    context "when nothing has been configured" do
      it "should be unsubscribed" do
        resident = create(:resident)

        expect(resident.subscribed_status).to eq("unsubscribed")
      end
    end
  end
end
