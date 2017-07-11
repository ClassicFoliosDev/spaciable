# frozen_string_literal: true
require "rails_helper"
RSpec.describe PlotCompareService do
  context "comparing two plots by prefix and number" do
    let(:unit_type) { create(:unit_type) }

    it "should sort based on plot prefixes" do
      plot1 = FactoryGirl.create(:plot, prefix: "Plot", number: "1", unit_type: unit_type)
      plot2 = FactoryGirl.create(:plot, prefix: "Apartment", number: "1", unit_type: unit_type)
      plot3 = FactoryGirl.create(:plot, prefix: "", number: "1", unit_type: unit_type)

      plot_array = []
      plot_array << plot1
      plot_array << plot2
      plot_array << plot3

      result = plot_array.sort

      expect(result[0].to_s).to eq("1")
      expect(result[1].to_s).to eq("Apartment 1")
      expect(result[2].to_s).to eq("Plot 1")
    end

    it "should sort based on numbers if prefixes are equal" do
      plot1 = FactoryGirl.create(:plot, prefix: "", number: "3", unit_type: unit_type)
      plot2 = FactoryGirl.create(:plot, prefix: "", number: "2", unit_type: unit_type)
      plot3 = FactoryGirl.create(:plot, prefix: "", number: "1", unit_type: unit_type)
      plot4 = FactoryGirl.create(:plot, prefix: "", number: "11", unit_type: unit_type)
      plot5 = FactoryGirl.create(:plot, prefix: "", number: "10", unit_type: unit_type)

      plot_array = []
      plot_array << plot1
      plot_array << plot2
      plot_array << plot3
      plot_array << plot4
      plot_array << plot5

      result = plot_array.sort

      expect(result[0].to_s).to eq("1")
      expect(result[1].to_s).to eq("2")
      expect(result[2].to_s).to eq("3")
      expect(result[3].to_s).to eq("10")
      expect(result[4].to_s).to eq("11")
    end

    it "should cope with decimal plot numbers" do
      plot1 = FactoryGirl.create(:plot, prefix: "Plot", number: "1.1.4", unit_type: unit_type)
      plot2 = FactoryGirl.create(:plot, prefix: "Plot", number: "1.1.6", unit_type: unit_type)
      plot3 = FactoryGirl.create(:plot, prefix: "Plot", number: "1.1", unit_type: unit_type)

      plot_array = []
      plot_array << plot1
      plot_array << plot2
      plot_array << plot3

      result = plot_array.sort
      expect(result.length).to eq(3)

      expect(result[0].to_s).to eq("Plot 1.1")
      expect(result[1].to_s).to eq("Plot 1.1.4")
      expect(result[2].to_s).to eq("Plot 1.1.6")
    end

    it "should cope with alphanumeric plot numbers" do
      plot1 = FactoryGirl.create(:plot, prefix: "", number: "11A", unit_type: unit_type)
      plot2 = FactoryGirl.create(:plot, prefix: "", number: "10c", unit_type: unit_type)
      plot3 = FactoryGirl.create(:plot, prefix: "", number: "10", unit_type: unit_type)
      plot4 = FactoryGirl.create(:plot, prefix: "", number: "11", unit_type: unit_type)

      plot_array = []
      plot_array << plot1
      plot_array << plot2
      plot_array << plot3
      plot_array << plot4

      result = plot_array.sort
      expect(result.length).to eq(4)

      expect(result[0].to_s).to eq("10")
      expect(result[1].to_s).to eq("10c")
      expect(result[2].to_s).to eq("11")
      expect(result[3].to_s).to eq("11A")
    end
  end
end
