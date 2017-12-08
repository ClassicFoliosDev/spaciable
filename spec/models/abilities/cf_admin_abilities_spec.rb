# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "CF Admin Abilities" do
  let(:current_user) { create(:cf_admin) }

  subject { Ability.new(current_user) }

  describe "accessing residencies" do
    it "should CRUD residencies under their developments plots" do
      development = create(:development)
      plot = create(:plot, development: development)
      resident = create(:resident, :with_residency, plot: plot)

      expect(subject).to be_able_to(:crud, resident.plot_residencies.first)
    end

    it "should CRUD residencies under their developments phase plots" do
      development = create(:development)
      phase = create(:phase, development: development)
      phase_plot = create(:phase_plot, phase: phase)
      resident = create(:resident, :with_residency, plot: phase_plot)

      expect(subject).to be_able_to(:crud, resident.plot_residencies.first)
    end

    it "can create a first residency for a plot" do
      development = create(:development)
      plot = create(:plot, development: development)
      resident = create(:resident)

      first_residency = PlotResidency.new(resident: resident, plot: plot)

      expect(subject).to be_able_to(:create, first_residency)
    end

    it "can create a second residency for the same plot" do
      development = create(:development)
      plot = create(:plot, development: development)
      create(:resident, :with_residency, plot: plot)

      second_residency = PlotResidency.new(resident: create(:resident), plot: plot)

      expect(subject).to be_able_to(:create, second_residency)
    end
  end
end
