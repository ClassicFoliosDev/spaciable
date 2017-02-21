# frozen_string_literal: true
require "rails_helper"

RSpec.describe BulkPlots::CreateService do
  it "should return true" do
    params = { list: "3" }
    service = described_class.call(create(:plot), params: params)

    expect(service.save).to eq(true)
  end

  context "when no plots already exist" do
    it "should create all of the plots" do
      params = { range_from: 1, range_to: 3, prefix: "Marsh" }
      development = create(:development)
      plot = build(:plot, development: development)
      service = described_class.call(plot, params: params)

      expect { service.save }.to change(Plot, :count).by(3)
      expect(Plot.where(number: [1, 2, 3], prefix: "Marsh").count).to eq(3)
      expect(development.reload.plots.count).to eq(3)
    end
  end

  context "when some of the plots already exist" do
    it "should overwrite the attributes of the existing plots" do
      params = { range_from: 1, range_to: 3, prefix: "Marsh" }
      development = create(:development)
      plot = create(:plot, development: development, number: 3, prefix: "Marsh")
      service = described_class.call(plot, params: params)

      expect { service.save }.to change(Plot, :count).by(2)
      expect(Plot.where(number: [1, 2, 3], prefix: "Marsh").count).to eq(3)
      expect(development.reload.plots.count).to eq(3)
    end
  end

  context "when no numbers are supplied" do
    it "should not update any plots" do
      params = { prefix: "Hillock" }
      plot = build(:plot)
      service = described_class.call(plot, params: params)

      expect { service.save }.to change(Plot, :count).by(0)
    end

    it "should return a validation error" do
      params = { prefix: "Hillock" }
      plot = build(:plot)
      service = described_class.call(plot, params: params)

      result = service.save

      expect(service.collection.errors).not_to be_empty
      expect(result).to eq(false)
    end
  end

  context "when the plots are invalid" do
    it "should expose plots that could not be saved" do
      params = { list: "1,2", prefix: "Hillock", development_id: nil }
      plot = build(:plot)
      service = described_class.call(plot, params: params)

      service.save

      expect(service.errors).to include("Plots 1 and 2 could not be saved: Development  is required")
    end
  end
end
