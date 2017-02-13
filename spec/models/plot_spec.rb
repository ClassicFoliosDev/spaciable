# frozen_string_literal: true
require "rails_helper"

RSpec.describe Plot do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:development) }
    let(:association_with_parent) { :plots }
  end
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:phase) }
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

  describe "#build_resident" do
    it "should build a resident associated with the plot" do
      plot = create(:plot)

      resident = plot.build_resident

      expect(resident.plot).to eq(plot)
    end
  end

  describe "#destroy" do
    subject { FactoryGirl.create(:plot) }

    include_examples "archive when destroyed"
    it_behaves_like "archiving is dependent on parent association", :developer
    it_behaves_like "archiving is dependent on parent association", :division do
      subject { FactoryGirl.create(:plot, development: create(:division_development)) }
    end
    it_behaves_like "archiving is dependent on parent association", :development
    it_behaves_like "archiving is dependent on parent association", :unit_type
  end
end
