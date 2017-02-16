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

  describe "#address" do
    context "no plot address has been set" do
      it "should use the parents address" do
        parent = create(:development, :with_address)
        plot = create(:plot, development: parent)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(parent.building_name)
        expect(plot.road_name).to eq(parent.road_name)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(parent.postcode)
      end
    end

    context "if parts of the plot address have been reset" do
      it "should show the parent address fields" do
        parent = create(:development, :with_address)
        plot = create(:plot, development: parent)
        create(:address, addressable: plot, building_name: "", road_name: "", postcode: "")

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(parent.building_name)
        expect(plot.road_name).to eq(parent.road_name)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(parent.postcode)
      end
    end

    context "parts of the plot address have been set" do
      it "should use the parents address for a missing building name" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent)
        plot_address = create(:address, addressable: plot, building_name: nil)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(parent.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(plot_address.postcode)
      end

      it "should use the parents address for a missing building name" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent)
        plot_address = create(:address, addressable: plot, road_name: nil)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(parent.road_name)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(plot_address.postcode)
      end

      it "should use the parents address for a missing postcode" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent)
        plot_address = create(:address, addressable: plot, postcode: nil)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(parent.postcode)
      end
    end

    context "all plot address fields have been set" do
      it "should use the parents address for the missing fields" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent)
        plot_address = create(:address, addressable: plot)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(plot_address.postcode)
      end
    end

    context "when the parent address has been updated" do
      it "should show the update fields that have not been overridden" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent)
        plot_address = create(:address, addressable: plot)

        parent.address.update(city: "Best City", county: "The best county")

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.city).to eq("Best City")
        expect(plot.county).to eq("The best county")
        expect(plot.postcode).to eq(plot_address.postcode)
      end

      it "should return the overridden fields, not the parent fields" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent)
        plot_address = create(:address, addressable: plot)

        parent.address.update(
          building_name: "new building name",
          road_name: "wonky road",
          city: "Best City",
          county: "The best county",
          postcode: "SP10 4RR"
        )

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.city).to eq("Best City")
        expect(plot.county).to eq("The best county")
        expect(plot.postcode).to eq(plot_address.postcode)
      end
    end
  end

  describe "#address=" do
    describe "should persist fields that are different from the parent address" do
      it "for the postcode" do
        parent = create(:development, :with_address)
        plot = build(:plot, development: parent)

        plot.building_name = parent.building_name
        plot.road_name = parent.road_name
        plot.postcode = "RG19 8UI"

        plot.save!

        expect(plot.address.building_name).to be_nil
        expect(plot.address.road_name).to be_nil
        expect(plot.address.postcode).to eq("RG19 8UI")
      end

      it "for the road name" do
        parent = create(:development, :with_address)
        plot = build(:plot, development: parent)

        plot.building_name = parent.building_name
        plot.road_name = "Cheery road"
        plot.postcode = parent.postcode
        plot.save!

        expect(plot.address.building_name).to be_nil
        expect(plot.address.road_name).to eq("Cheery road")
        expect(plot.address.postcode).to be_nil
      end

      it "for the building name" do
        parent = create(:development, :with_address)
        plot = build(:plot, development: parent)

        plot.building_name = "Tallest building"
        plot.road_name = parent.road_name
        plot.postcode = parent.postcode
        plot.save!

        expect(plot.address.building_name).to eq("Tallest building")
        expect(plot.address.road_name).to be_nil
        expect(plot.address.postcode).to be_nil
      end
    end

    it "should not create an address in the database if no keys have been overridden" do
      parent = create(:development, :with_address)
      plot = create(:plot, development: parent)

      plot.building_name = parent.building_name
      plot.road_name = parent.road_name
      plot.postcode = parent.postcode
      plot.city = parent.city
      plot.county = parent.county

      expect(plot.address).to be_nil
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
