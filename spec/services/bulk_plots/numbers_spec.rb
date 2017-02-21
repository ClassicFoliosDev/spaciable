# frozen_string_literal: true
require "rails_helper"

RSpec.describe BulkPlots::Numbers do
  context "when given a range" do
    it "should return the numbers of the range" do
      params = { range_from: 10, range_to: 15 }

      result = described_class.new(params).numbers

      expect(result).to match_array([10, 11, 12, 13, 14, 15])
    end
  end

  context "when given a range from without a range to" do
    it "should not return any numbers" do
      params = { range_from: 10 }

      result = described_class.new(params).numbers

      expect(result).to be_empty
    end
  end

  context "when given a range to without a range from" do
    it "should not return any numbers" do
      params = { range_to: 20 }

      result = described_class.new(params).numbers

      expect(result).to be_empty
    end
  end

  context "when given a list" do
    it "should return the numbers from the list" do
      params = { list: "3,5,10" }

      result = described_class.new(params).numbers

      expect(result).to match_array([3, 5, 10])
    end
  end

  context "when given an overlapping range and list" do
    it "should return an array of unique numbers" do
      params = { list: "3,5,8", range_from: 5, range_to: 10 }

      result = described_class.new(params).numbers

      expect(result).to match_array([3, 5, 6, 7, 8, 9, 10])
    end
  end

  context "when the list value is present but cannot be converted to integers" do
    it "should not return any numbers" do
      params = { list: "New york, new york!" }

      result = described_class.new(params).numbers

      expect(result).to be_empty
    end
  end
end
