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
      params = { range_from: 1, range_to: 3, list: "5.5, 6.6", prefix: "Marsh" }
      development = create(:development)
      plot = build(:plot, development: development)
      service = described_class.call(plot, params: params)

      expect { service.save }.to change(Plot, :count).by(5)
      expect(Plot.where(number: [1, 2, 3, "5.5", "6.6"], prefix: "Marsh").count).to eq(5)
      expect(development.reload.plots.count).to eq(5)
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

  context "when plots exist with the same prefix under other developments" do
    it "should create the plots under this development" do
      other_plot = create(:plot, number: 1, prefix: "Riverway")
      params = { range_from: 1, range_to: 5, prefix: "Riverway", house_number: "88" }
      development = create(:development)
      plot = build(:plot, development: development)
      service = described_class.call(plot, params: params)

      expect { service.save }.to change { development.plots.count }.by(5)
      expect(other_plot.house_number).not_to eq(params[:house_number])
    end
  end

  context "when the parent has no address" do
    it "should save a new address for each plot" do
      params = { range_from: 1, range_to: 5, building_name: "Mega Shed", road_name: "Wonky road", postcode: "ABC 123" }
      plot = build(:plot)
      query = Plot.joins(:address).where(
        addresses: {
          building_name: params[:building_name],
          road_name: params[:road_name],
          postcode: params[:postcode]
        }
      )

      expect { described_class.call(plot, params: params).save }.to change { query.count }.by(5)
    end
  end

  context "when adding a single invalid plot" do
    it "should not return as successful" do
      existing_plot = create(:plot, number: "1")
      base_plot = build(:plot, development: existing_plot.development)
      params = { list: "1" }

      described_class.call(base_plot, params: params) do |_service, created_plots, errors|
        expect(created_plots).to be_empty
        expect(errors).to include(I18n.t("activerecord.errors.models.plot.attributes.base.number_taken"))
      end
    end
  end

  context "when the plots are invalid" do
    it "should expose plots that could not be saved" do
      prefix = "Hillock"
      phase = create(:phase)
      create(:phase_plot, number: "1", prefix: prefix, phase: phase)
      create(:phase_plot, number: "2", prefix: prefix, phase: phase)

      base_plot = build(:phase_plot, prefix: prefix, phase: phase)
      params = { list: "1, 2", prefix: prefix }

      described_class.call(base_plot, params: params) do |_service, created_plots, errors|
        expect(created_plots).to be_empty
        expect(errors).to include(I18n.t("activerecord.errors.models.plot.attributes.base.combination_taken"))
      end
    end
  end

  context "given a valid plot list" do
    it "should create all the plots" do
      params = { list: " 1, 1a, 1A, 10, 100, 1000, 1.1, 1.1A, 1.1a, 1.1.1, 1.1.1.1, 1.10, 1.1.10, 1.1.1.10, A1, a1", prefix: "Hollow" }
      development = create(:development)
      plot = build(:plot, development: development)
      service = described_class.call(plot, params: params)

      expect { service.save }.to change(Plot, :count).by(16)
      expect(Plot.where(prefix: "Hollow").count).to eq(16)
      result_test = params[:list].split(",").map { |plot_number| "Hollow#{plot_number}" }
      expect(development.reload.plots.map(&:to_s)).to match_array(result_test)
    end
  end
end
