# frozen_string_literal: true
require "rails_helper"

RSpec.describe Resident do
  describe "#plot=" do
    context "without an existing plot residency" do
      it "should create a new plot residency to access the plot" do
        resident = create(:resident)
        plot = create(:plot)

        resident.plot = plot
        resident.save
        resident.reload

        expect(resident.plot_residency).not_to be_nil
        expect(resident.plot_residency.plot_id).to eq(plot.id)
        expect(resident.plot_residency.resident_id).to eq(resident.id)
        expect(resident.plot).to eq(plot)
      end
    end

    context "already with a plot_residency" do
      it "should update an existing plot residency" do
        resident = create(:resident, :with_residency)

        new_plot = create(:plot)

        resident.update(plot: new_plot)
        resident.reload

        expect(resident.plot_residency.plot_id).to eq(new_plot.id)
        expect(resident.plot_residency.resident_id).to eq(resident.id)
        expect(resident.reload.plot).to eq(new_plot)
      end
    end

    context "with valid phone number" do
      resident = described_class.new(email: "test@example.com",
                                     first_name: "Joe",
                                     last_name: "Bloggs",
                                     password: "passw0rd",
                                     phone_number: "07768 321456")
      it "should be a valid resident" do
        expect(resident).to be_valid
      end
    end

    context "with invalid contents" do
      resident = described_class.new(phone_number: "07768 32145")
      it "should not be a valid resident" do
        expect(resident).not_to be_valid

        required = " is required, and must not be blank."
        expect(resident.errors.messages[:email]).to include(required)
        expect(resident.errors.messages[:first_name]).to include(required)
        expect(resident.errors.messages[:last_name]).to include(required)
        expect(resident.errors.messages[:password]).to include(required)
        expect(resident.errors.messages[:phone_number]).to include("is invalid")
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
end
