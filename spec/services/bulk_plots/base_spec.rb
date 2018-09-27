# frozen_string_literal: true

require "rails_helper"

RSpec.describe BulkPlots::Base do
  describe ".call" do
    it "should pass on attributes from the plot argument to the plots model instance" do
      development = create(:development)
      plot = create(:plot, development: development)

      result = described_class.call(plot).collection

      expect(result.development_id).to eq(development.id)
    end
  end

  describe "#plots" do
    it "can hold information for multiple plot numbers" do
      result = described_class.call.collection

      expect(result).to respond_to(:range_from)
      expect(result).to respond_to(:range_to)
      expect(result).to respond_to(:list)
    end
  end

  describe "#bulk_attributes" do
    it "should generate an array of plot attributes for each number" do
      params = { list: "1,3,5" }

      result = described_class.call(nil, params: params).bulk_attributes

      values = result.map { |hash| hash[:number] }
      expect(values).to match_array(%w[1 3 5])
    end

    it "should populate the attributes with those passed in as params" do
      params = { range_from: 1, range_to: 3 }

      result = described_class.call(nil, params: params).bulk_attributes
      expect(result.pluck(:number)).to eq [1, 2, 3]
    end

    it "should populate attributes from the plots attributes" do
      params = { range_from: 1, range_to: 3 }
      phase = create(:phase)
      plot = create(:phase_plot, phase: phase)

      result = described_class.call(plot, params: params).bulk_attributes

      values = result.map { |hash| hash[:phase_id] }
      expect(values).to all eq(phase.id)
    end

    it "should override plot attributes with params" do
      params = { range_from: 1, range_to: 3, unit_type_id: 2 }
      plot = build(:plot, unit_type_id: 1)

      result = described_class.call(plot, params: params).bulk_attributes

      values = result.map { |hash| hash[:unit_type_id] }
      expect(values).to all eq(params[:unit_type_id])
    end

    it "should exclude the id and timestamp attributes from a persisted plot" do
      params = { list: "3" }
      plot = create(:plot)

      result = described_class.call(plot, params: params).bulk_attributes

      only_result = result[0]
      expect(only_result.key?(:id)).to eq(false)
      expect(only_result.key?(:created_at)).to eq(false)
      expect(only_result.key?(:updated_at)).to eq(false)
    end
  end
end
