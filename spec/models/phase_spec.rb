# frozen_string_literal: true
require "rails_helper"

RSpec.describe Phase do
  it "must have a developer_id or division_id" do
    phase = described_class.new(developer_id: nil, division_id: nil)

    phase.validate

    expect(phase.errors[:base]).to include("be associated with a Developer or Division")
  end

  describe "#developer_id" do
    it "sets it based on the development developer_id" do
      developer = create(:developer)
      development = create(:development, developer: developer, division: nil)
      phase = development.phases.new

      phase.validate

      expect(phase.developer_id).to eq(developer.id)
    end
  end

  describe "#division_id" do
    it "sets it based on the development division_id" do
      division = create(:division)
      development = create(:development, division: division, developer: division.developer)
      phase = development.phases.new

      phase.validate

      expect(phase.division_id).to eq(division.id)
    end

    it "does not set the developer_id if the development has a division id" do
      division = create(:division)
      developer = division.developer
      development = create(:development, developer: developer, division: division)
      phase = development.phases.new

      phase.validate

      expect(phase.division_id).to eq(division.id)
      expect(phase.developer_id).to be_nil
    end
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
