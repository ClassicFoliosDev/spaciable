# frozen_string_literal: true
require "rails_helper"

RSpec.describe Plot do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:development) }
    let(:association_with_parent) { :plots }
  end

  describe "#number" do
    context "is a decimal" do
      it "is displayed as a decimal" do
        plot = Plot.new(number: 3.5)

        expect(plot.to_s).to eq("3.5")
      end
    end

    context "is a whole number" do
      it "is displayed as a whole number" do
        plot = Plot.new(number: 3)

        expect(plot.to_s).to eq("3")
      end
    end
  end
end
