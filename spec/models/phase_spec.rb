# frozen_string_literal: true
require "rails_helper"

RSpec.describe Phase do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:development) }
    let(:association_with_parent) { :phases }
  end

  describe "#number" do
    it "should start at 1" do
      phase = described_class.new

      expect(phase.number).to eq(1)
    end

    it "can be overriden" do
      phase = create(:phase, number: 100)

      expect(phase.number).to eq(100)
    end

    context "within the same development" do
      it "should increment by one" do
        development = create(:development)
        create(:phase, development: development)
        second_phase = create(:phase, development: development)

        expect(second_phase.number).to eq(2)
      end

      it "should raise an exception if another phase has that number" do
        development = create(:development)
        first_phase = create(:phase, development: development)
        second_phase = build(
          :phase,
          development: development,
          number: first_phase.number
        )

        second_phase.validate

        expect(second_phase.errors[:number]).not_to be_empty
      end
    end

    context "within separate developments" do
      it "should allow the same number" do
        a_phase = create(:phase)
        another_phase = create(:phase)

        expect(a_phase.number).to eq(1)
        expect(another_phase.number).to eq(1)
      end
    end
  end

  describe "#build_address_with_defaults" do
    it "uses the developments address if blank" do
      development = create(:development)
      development_address = development.address
      phase = development.phases.new

      phase.build_address_with_defaults

      expect(phase.address.postal_name).to eq(development_address.postal_name)
      expect(phase.address.building_name).to eq(development_address.building_name)
      expect(phase.address.road_name).to eq(development_address.road_name)
      expect(phase.address.city).to eq(development_address.city)
      expect(phase.address.county).to eq(development_address.county)
      expect(phase.address.postcode).to eq(development_address.postcode)
    end

    it "builds an empty address if development does not have an address" do
      development = create(:development, address: nil)
      phase = development.phases.new

      phase.build_address_with_defaults

      expect(phase.address).not_to be_nil
    end
  end

  describe "#destroy" do
    it "should be archived" do
      phase = create(:phase)

      phase.destroy!

      expect(described_class.all).not_to include(phase)
      expect(described_class.with_deleted).to include(phase)
    end

    it "should be archived when the development is destroyed" do
      phase = create(:phase)

      phase.development.destroy!

      expect(described_class.all).not_to include(phase)
      expect(described_class.with_deleted).to include(phase)
    end
  end
end
