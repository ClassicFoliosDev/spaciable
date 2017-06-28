# frozen_string_literal: true
require "rails_helper"

RSpec.describe CloneNameService do
  context "name ending in letter" do
    it "appends a one" do
      result = described_class.call("A name that ends with a letter")

      expect(result).to eq("A name that ends with a letter 1")
    end
  end

  context "name ending in number" do
    it "increments the end" do
      result = described_class.call("A name that ends with 111")

      expect(result).to eq("A name that ends with 112")
    end
  end

  context "name ending in 999" do
    it "increments the end" do
      result = described_class.call("A name that ends with 999")

      expect(result).to eq("A name that ends with 1000")
    end
  end

  context "name ending in 10" do
    it "increments the end" do
      result = described_class.call("A name that ends with 10")

      expect(result).to eq("A name that ends with 11")
    end
  end

  context "name ending in 210" do
    it "increments the end" do
      result = described_class.call("A name that ends with 210")

      expect(result).to eq("A name that ends with 211")
    end
  end

  context "name ending in 99" do
    it "increments the end" do
      result = described_class.call("A name that ends with 99")

      expect(result).to eq("A name that ends with 100")
    end
  end

  context "name ending in 9" do
    it "increments the end" do
      result = described_class.call("A name that ends with 9")

      expect(result).to eq("A name that ends with 10")
    end
  end

  context "name with several numbers ending in 0" do
    it "increments the end" do
      result = described_class.call("A name with 44 48960 that ends with 190")

      expect(result).to eq("A name with 44 48960 that ends with 191")
    end
  end

  context "name with several numbers ending in a letter" do
    it "increments the end" do
      result = described_class.call("A name with 44 and 76542 that ends with a letter")

      expect(result).to eq("A name with 44 and 76542 that ends with a letter 1")
    end
  end
end
