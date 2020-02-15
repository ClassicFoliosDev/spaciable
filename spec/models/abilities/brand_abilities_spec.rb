# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Brand Abilities" do

  let(:resident) { create(:resident, :with_residency) }

  context "when a developer has a brand" do
    subject { Ability.new(resident, plot: resident.plots.first) }
    it "should have READ access to the developers brand" do
      brand = create(:brand, brandable: resident.plots.first.developer)

      expect(subject).to be_able_to(:read, brand)
    end
  end

  context "when a division has a brand" do
    subject { Ability.new(resident, plot: resident.plots.first) }
    let(:resident) do
      plot = create(:plot, development: create(:division_development))
      create(:resident, :with_residency, plot: plot)
    end

    it "should have READ access to the divisions brand" do
      brand = create(:brand, brandable: resident.plots.first.division)

      expect(subject).to be_able_to(:read, brand)
    end
  end

  context "when another division has a brand" do
    subject { Ability.new(resident, plot: resident.plots.first) }
    let(:resident) do
      plot = create(:plot, development: create(:division_development))
      create(:resident, :with_residency, plot: plot)
    end

    it "should not have READ access to the other division brand" do
      other_division = create(:division, developer: resident.plots.first.developer)
      brand = create(:brand, brandable: other_division)

      expect(subject).not_to be_able_to(:read, brand)
    end

    it "should not have READ access to the other division brand" do
      other_division_development = create(:division_development, division: resident.plots.first.division)
      brand = create(:brand, brandable: other_division_development)

      expect(subject).not_to be_able_to(:read, brand)
    end
  end

  context "when a development has a brand" do
    subject { Ability.new(resident, plot: resident.plots.first) }
    it "should have READ access to the divisions brand" do
      brand = create(:brand, brandable: resident.plots.first.development)

      expect(subject).to be_able_to(:read, brand)
    end
  end

  context "when a phase has a brand" do
    subject { Ability.new(resident, plot: resident.plots.first) }
    let(:resident) { create(:resident, :with_residency, plot: create(:phase_plot)) }

    it "should have READ access to the phase brand" do
      brand = create(:brand, brandable: resident.plots.first.phase)

      expect(subject).to be_able_to(:read, brand)
    end
  end
end
