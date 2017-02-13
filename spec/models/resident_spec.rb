# frozen_string_literal: true
require "rails_helper"

RSpec.describe Resident do
  describe "#plot=" do
    context "without an existing plot residency" do
      it "should create a new plot residency to access the plot" do
        resident = create(:resident)
        plot = create(:plot)

        resident.plot = plot

        expect(resident.plot_residency.plot_id).to eq(plot.id)
        expect(resident.plot_residency.resident_id).to eq(resident.id)
        expect(resident.reload.plot).to eq(plot)
      end
    end

    context "already with a plot_residency" do
      it "should update an existing plot residency" do
        resident = create(:resident, :with_residency)

        new_plot = create(:plot)

        resident.update(plot: new_plot)

        expect(resident.plot_residency.plot_id).to eq(new_plot.id)
        expect(resident.plot_residency.resident_id).to eq(resident.id)
        expect(resident.reload.plot).to eq(new_plot)
      end
    end
  end

  describe "#developer" do
    it "should return the plots developer" do
      resident = create(:resident, :with_residency)
      plot = resident.plot

      expect(resident.developer).to eq(plot.developer)
    end

    context "for a phase residency" do
      it "should return the plots developer" do
        resident = create(:resident, :with_residency)
        plot = resident.plot

        raise "no developer" unless plot.developer

        expect(resident.developer).to eq(plot.developer)
      end
    end
  end

  describe "#division" do
    it "should return the plots division" do
      division_development = create(:division_development)
      plot = create(:plot, development: division_development)
      resident = create(:resident, :with_residency, plot: plot)

      raise "no division" unless plot.division

      expect(resident.division).to eq(plot.division)
    end

    context "for a phase residency" do
      it "should return the phase plots division" do
        division_development = create(:division_development)
        phase = create(:phase, development: division_development)
        plot = create(:phase_plot, phase: phase)
        resident = create(:resident, :with_residency, plot: plot)

        raise "no division" unless plot.division

        expect(resident.division).to eq(plot.division)
      end
    end
  end

  describe "#development" do
    it "should return the plots development" do
      resident = create(:resident, :with_residency)
      plot = resident.plot

      expect(resident.development).to eq(plot.development)
    end

    context "for a phase residency" do
      it "should return the plots development" do
        division_development = create(:division_development)
        phase = create(:phase, development: division_development)
        plot = create(:phase_plot, phase: phase)
        resident = create(:resident, :with_residency, plot: plot)

        raise "no development" unless plot.development

        expect(resident.development).to eq(plot.development)
      end
    end
  end

  describe "#phase" do
    context "for a phase residency" do
      it "should return the plots phase" do
        plot = create(:phase_plot)
        resident = create(:resident, :with_residency, plot: plot)

        expect(resident.phase).to eq(plot.phase)
      end
    end
  end

  describe "#brand" do
    it "should use the lowest denominator of permissions" do
      developer = create(:developer)
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      phase = create(:phase, development: division_development)
      plot = create(:phase_plot, phase: phase)
      resident = create(:resident, :with_residency, plot: plot)

      developer_brand = create(:brand)
      developer.brands << developer_brand
      expect(resident.reload.brand).to eq(developer_brand)

      division_brand = create(:brand)
      division.brands << division_brand
      expect(resident.reload.brand).to eq(division_brand)

      development_brand = create(:brand)
      division_development.brands << development_brand
      expect(resident.reload.brand).to eq(development_brand)

      phase_brand = create(:brand)
      phase.brands << phase_brand
      expect(resident.reload.brand).to eq(phase_brand)
    end
  end
end
