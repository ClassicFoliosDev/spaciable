# frozen_string_literal: true
require "rails_helper"

RSpec.describe BulkPlots::Numbers do
  describe ".Number" do
    context "is a decimal" do
      it "is displayed as a string decimal" do
        result = described_class.Number(3.5)

        expect(result).to be(3.5)
      end

      it "should maintain string representation" do
        result = described_class.Number("3.5")

        expect(result).to eq("3.5")
      end
    end

    context "is a decimal that could be a whole number" do
      it "is displayed as a decimal" do
        result = described_class.Number(3.0)

        expect(result).to be(3.0)
      end
    end

    context "is a decimal that has trailing zeros" do
      it "is displayed with trailing zeros" do
        result = described_class.Number(5.2000)

        expect(result).to be(5.2000)
      end
    end

    context "is a string with multiple dots" do
      it "is displayed with multiple dots" do
        result = described_class.Number("7.2.1")

        expect(result).to eq("7.2.1")
      end
    end

    context "is a string with multiple dots and trailing zeros" do
      it "is displayed with trailing zeros" do
        result = described_class.Number("1.12.000")

        expect(result).to eq("1.12.000")
      end
    end

    context "is a whole number" do
      it "is displayed as a whole number" do
        result = described_class.Number(3)

        expect(result).to be(3)
      end
    end

    context "when not given a number" do
      it "should tolerate the mixed characters" do
        result = described_class.Number("Holy cow!")
        expect(result).to eq("Holy cow!")

        result = described_class.Number("63a")
        expect(result).to eq("63a")
      end
    end
  end

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

      expect(result).to match_array(%w(3 5 10))
    end

    it "should return floats from the list" do
      params = { list: "3.1, 0.5, 10.6, 4.20" }

      result = described_class.new(params).numbers

      expect(result).to match_array(["3.1", "0.5", "10.6", "4.20"])
    end
  end

  context "when given an overlapping range and list" do
    it "should return an array of unique numbers" do
      params = { list: "3,5,8", range_from: 5, range_to: 10 }

      result = described_class.new(params).numbers

      expect(result).to match_array([5, 6, 7, 8, 9, 10, "3", "5", "8"])
    end
  end

  context "when the list value is present but cannot be converted to integers" do
    it "should tolerate the string" do
      params = { list: "New york, new york!" }

      result = described_class.new(params).numbers

      expect(result).to eq(["New york", "new york!"])
    end
  end
end
