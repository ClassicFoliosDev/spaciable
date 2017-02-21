# frozen_string_literal: true
require "rails_helper"

RSpec.describe BulkPlots::UpdateService do
  context "when the plots already exist" do
    it "should update the existing plots that match the prefix and number" do
      params = { range_from: 1, range_to: 2, prefix: "Marsh", house_number: "100" }
      plot = create(:plot, prefix: "Marsh", number: 1, house_number: "70")
      plot_without_prefix = create(:plot, prefix: nil, number: 1, house_number: "70")
      service = described_class.call(plot)

      expect { service.update(params) }.not_to change(Plot, :count)
      expect(plot.reload.house_number).to eq(params[:house_number])
      expect(plot_without_prefix.reload.house_number).to eq("70")
    end
  end

  context "when some of the plots to be updated do not exist" do
    it "should return the missing plot numbers" do
      params = { range_from: 1, range_to: 5, prefix: "Hilltop" }
      plot = create(:plot, number: 1, prefix: "Hilltop")
      service = described_class.call(plot)

      expect { service.update(params) }.not_to change(Plot, :count)

      error = "Plots 2, 3, 4, and 5 could not be saved: Plot number not found with a prefix of 'Hilltop'"
      expect(service.errors).to include(error)
    end
  end

  describe "removing a prefix" do
    it "should remove the prefix" do
      params = { range_from: 1, range_to: 2, prefix: "" }
      plot = create(:plot, prefix: "Marsh", number: 1)
      service = described_class.call(plot)

      expect { service.update(params) }.not_to change(Plot, :count)

      expect(plot.reload.prefix).to eq(params[:prefix])
    end
  end

  describe "adding a plot prefix" do
    it "should add the prefix to the plot" do
      params = { range_from: 1, range_to: 2, prefix: "Plot" }
      plot = create(:plot, prefix: "", number: 1)
      service = described_class.call(plot)

      expect { service.update(params) }.not_to change(Plot, :count)

      expect(plot.reload.prefix).to eq(params[:prefix])
    end
  end
end
