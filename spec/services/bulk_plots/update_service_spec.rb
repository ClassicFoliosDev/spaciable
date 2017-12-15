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

    it "should update all of the unit type associations" do
      development = create(:development)
      unit_type = create(:unit_type)
      plot1 = create(:plot, prefix: "Marsh", number: 1, unit_type: unit_type, development: development)
      plot2 = create(:plot, prefix: "Marsh", number: 2, unit_type: unit_type, development: development)
      plot3 = create(:plot, prefix: "Marsh", number: 3, unit_type: unit_type, development: development)

      params = { range_from: "1", range_to: "5", list: "2", prefix: "Marsh", unit_type_id: unit_type.id }

      described_class.call(plot1).update(params)

      expect(plot1.reload.unit_type_id).to eq(unit_type.id)
      expect(plot2.reload.unit_type_id).to eq(unit_type.id)
      expect(plot3.reload.unit_type_id).to eq(unit_type.id)
    end

    it "should update plots with decimal places supplied as a list" do
      development = create(:development)
      unit_type = create(:unit_type)
      plot1 = create(:plot, number: 1.1, unit_type: unit_type, development: development)
      plot2 = create(:plot, number: 1.2, unit_type: unit_type, development: development)

      params = { list: "1.1, 1.2", unit_type_id: unit_type.id }

      described_class.call(plot1).update(params)

      expect(plot1.reload.unit_type_id).to eq(unit_type.id)
      expect(plot2.reload.unit_type_id).to eq(unit_type.id)
    end
  end

  context "when supplied with a number field" do
    it "should update the base plots number" do
      plot = create(:plot, number: 5)
      params = { number: 10 }

      described_class.call(plot).update(params)

      expect(plot.reload.number).to eq(params[:number].to_s)
    end
  end

  context "when plots accross developments share the same prefix" do
    it "should not update the other developments plots" do
      plot1 = create(:plot, prefix: "Marsh", number: 1, development: create(:development))
      plot2 = create(:plot, prefix: "Marsh", number: 2, development: create(:development))

      params = { range_from: "1", range_to: "2", prefix: "Marsh", house_number: "100" }

      described_class.call(plot1).update(params)

      expect(plot1.reload.house_number).to eq("100")
      expect(plot2.reload.house_number).not_to eq("100")
    end
  end

  context "when some of the plots to be updated do not exist" do
    it "should return the missing plot numbers" do
      params = { range_from: 1, range_to: 5, prefix: "Hilltop" }
      plot = create(:plot, number: 1, prefix: "Hilltop")

      described_class.call(plot, params: params) do |service, _, _|
        error = "Plots '2, 3, 4, and 5' could not be saved: Plot not found"

        expect(service.errors).to include(error)
      end
    end

    it "should not say the missing numbers have been updated" do
      params = { range_from: 2, range_to: "5", list: "1, 2", prefix: "Hilltop" }
      plot1 = create(:plot, number: 2, prefix: "Hilltop")
      create(:plot, number: 3, prefix: "Hilltop", development: plot1.development)

      described_class.call(plot1, params: params) do |service, _, _|
        expect(service.succeeded).to eq("Plots 2 and 3")
      end
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

  context "given a decimal plot number" do
    it "should update the plot" do
      create(:plot, prefix: "Marsh", number: "A1.1.10")
      params = { number: "A1.1.10", prefix: "Foo" }
      development = create(:development)
      plot = build(:plot, development: development)

      described_class.call(plot, params: params) do |service, _, _|
        expect(service.succeeded).to eq("Plot #{plot.id}")
      end
    end
  end
end
