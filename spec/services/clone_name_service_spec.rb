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
end
