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

  describe "#rooms" do
    context "when there are only unit type rooms" do
      it "should return all unit type rooms" do
        development = create(:development)
        development_admin = create(:development_admin, permission_level: development)
        unit_type = create(:unit_type)
        unit_type_rooms = create_list(:room, 3, unit_type: unit_type, last_updated_by: development_admin.display_name)
        plot = create(:plot, unit_type: unit_type)

        expect(plot.rooms).to match_array(unit_type_rooms)
      end
    end

    context "when there are plot_rooms as well as unit type rooms" do
      it "should return all plot_rooms and all unit_type rooms" do
        development = create(:development)
        development_admin = create(:development_admin, permission_level: development)
        unit_type = create(:unit_type)
        plot = create(:plot, unit_type: unit_type)

        unit_type_room = create(:room, unit_type: unit_type, last_updated_by: development_admin.display_name)
        plot_room = create(:room, plot: plot, last_updated_by: development_admin.display_name)

        expect(plot.rooms).to match_array([unit_type_room, plot_room])
      end
    end

    context "when plot rooms use a unit type room as a template" do
      it "should not return the unit type rooms that are being used as templates for plot rooms" do
        development = create(:development)
        development_admin = create(:development_admin, permission_level: development)
        unit_type = create(:unit_type)
        plot = create(:plot, unit_type: unit_type)

        unit_type_room = create(:room, unit_type: unit_type, last_updated_by: development_admin.display_name)
        plot_room = create(:room, plot: plot, template_room_id: unit_type_room.id, last_updated_by: development_admin.display_name)

        expect(plot.rooms).to match_array([plot_room])
      end
    end

    context "when a templated plot room has been deleted" do
      it "should not return the unit type room template" do
        development = create(:development)
        development_admin = create(:development_admin, permission_level: development)

        unit_type = create(:unit_type)
        plot = create(:plot, unit_type: unit_type)
        unit_type_room = create(:room, unit_type: unit_type, last_updated_by: development_admin.display_name)
        plot_room = create(:room, plot: plot, template_room_id: unit_type_room.id, last_updated_by: development_admin.display_name)
        plot_room.destroy

        expect(plot.rooms).to match_array([])
      end
    end

    context "when the template unit type room for a plot room has been deleted" do
      it "should still return the templated plot room" do
        development = create(:development)
        development_admin = create(:development_admin, permission_level: development)

        unit_type = create(:unit_type)
        plot = create(:plot, unit_type: unit_type)

        unit_type_room = create(:room, unit_type: unit_type, last_updated_by: development_admin.display_name)
        plot_room = create(:room, plot: plot, template_room_id: unit_type_room.id, last_updated_by: development_admin.display_name)
        unit_type_room.destroy

        expect(plot.rooms).to match_array([plot_room])
      end
    end
  end

  describe "#number_uniqueness" do
    context "under the same development" do
      it "should not allow duplicate plots" do
        number = 88

        development = create(:development)
        create(:plot, number: number, development: development)
        plot = Plot.new(number: number, development: development)

        plot.validate

        base_errors = plot.errors.details[:base]
        expect(base_errors).to include(error: :number_taken, value: plot.to_s)
      end
    end

    context "under different developments" do
      it "should allow duplicate plot numbers" do
        number = 88
        create(:plot, number: number)
        plot = Plot.new(number: number, development: create(:development))

        plot.validate

        base_errors = plot.errors.details[:base]
        expect(base_errors).not_to include(error: :number_taken, value: number.to_s)
      end
    end

    context "under the same phase" do
      it "should not allow duplicate plots" do
        number = 88

        phase = create(:phase)
        create(:phase_plot, number: number, phase: phase)
        plot = Plot.new(number: number, phase: phase)

        plot.validate

        base_errors = plot.errors.details[:base]
        expect(base_errors).to include(error: :number_taken, value: plot.to_s)
      end
    end

    context "under different phases" do
      it "should allow duplicate plot numbers" do
        number = 88
        create(:phase_plot, number: number)
        plot = Plot.new(number: number, phase: create(:phase))

        plot.validate
        base_errors = plot.errors.details[:base]
        expect(base_errors).not_to include(error: :number_taken, value: number.to_s)
      end
    end
  end

  describe "#number" do
    context "is a decimal" do
      it "is displayed as a decimal" do
        plot = Plot.new(number: 3.5)

        expect(plot.to_s).to eq("Plot 3.5")
      end
    end

    context "is a whole number" do
      it "is displayed as a whole number" do
        plot = Plot.new(number: 3)

        expect(plot.to_s).to eq("Plot 3")
      end
    end
  end

  describe "#address" do
    let(:plot_address) { create(:address, city: nil, county: nil, locality: nil) }

    context "no plot address has been set" do
      it "should use the parents address" do
        parent = create(:development, :with_address)
        plot = create(:plot, development: parent, address: nil)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(parent.building_name)
        expect(plot.road_name).to eq(parent.road_name)
        expect(plot.locality).to eq(parent.locality)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(parent.postcode)
      end
    end

    context "if parts of the plot address have been reset" do
      it "should show the parent address fields" do
        parent = create(:development, :with_address)
        address = create(:address, building_name: "", road_name: "", postcode: "")
        plot = create(:plot, development: parent, address: address)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(parent.building_name)
        expect(plot.road_name).to eq(parent.road_name)
        expect(plot.locality).to eq(parent.locality)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(parent.postcode)
      end
    end

    context "parts of the plot address have been set" do
      it "should use the parents address for a missing building name" do
        parent = create(:phase, :with_address)
        plot_address = create(:address, building_name: nil)
        plot = create(:phase_plot, phase: parent, address: plot_address)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(parent.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.locality).to eq(parent.locality)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(plot_address.postcode)
      end

      it "should use the parents address for a missing road name" do
        parent = create(:phase, :with_address)
        plot_address = create(:address, road_name: nil)
        plot = create(:phase_plot, phase: parent, address: plot_address)

        expect(plot.house_number).to be_nil
        expect(plot.road_name).to eq(parent.road_name)
        expect(plot.postcode).to eq(plot_address.postcode)
      end

      it "should use the parents address for a missing postcode" do
        parent = create(:phase, :with_address)
        plot_address = create(:address, postcode: nil)
        plot = create(:phase_plot, phase: parent, address: plot_address)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.postcode).to eq(parent.postcode)
      end
    end

    context "all plot address fields have been set" do
      it "should use the parents address for the missing fields" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent, address: plot_address)

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.locality).to eq(parent.locality)
        expect(plot.city).to eq(parent.city)
        expect(plot.county).to eq(parent.county)
        expect(plot.postcode).to eq(plot_address.postcode)
      end
    end

    context "when the parent address has been updated" do
      it "should show the update fields that have not been overridden" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent, address: plot_address)

        parent.address.update(city: "Best City", county: "The best county")

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.locality).to eq(parent.locality)
        expect(plot.city).to eq("Best City")
        expect(plot.county).to eq("The best county")
        expect(plot.postcode).to eq(plot_address.postcode)
      end

      it "should return the overridden fields, not the parent fields" do
        parent = create(:phase, :with_address)
        plot = create(:phase_plot, phase: parent, address: plot_address)

        parent.address.update(
          building_name: "new building name",
          road_name: "wonky road",
          locality: "Fun field",
          city: "Best City",
          county: "The best county",
          postcode: "SP10 4RR"
        )

        expect(plot.house_number).to be_nil
        expect(plot.building_name).to eq(plot_address.building_name)
        expect(plot.road_name).to eq(plot_address.road_name)
        expect(plot.locality).to eq("Fun field")
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
        plot = build(:plot, development: parent, address: nil)

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
        plot = build(:plot, development: parent, address: nil)

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
        plot = build(:plot, development: parent, address: nil)

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
      plot = create(:plot, development: parent, address: nil)

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

  describe "#brand" do
    it "should use the lowest denominator of permissions" do
      developer = create(:developer)
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      phase = create(:phase, development: division_development)
      plot = create(:phase_plot, phase: phase)

      developer_brand = create(:brand)
      developer.brands << developer_brand
      expect(plot.reload.brand).to eq(developer_brand)

      division_brand = create(:brand)
      division.brands << division_brand
      expect(plot.reload.brand).to eq(division_brand)

      development_brand = create(:brand)
      division_development.brands << development_brand
      expect(plot.reload.brand).to eq(development_brand)
    end
  end

  describe "#to_homeowner_s" do
    context "there is a house number" do
      it "should use the house number" do
        plot = create(:phase_plot, house_number: "14C", address: nil)

        expect(plot.to_homeowner_s).to eq "14C"
      end
    end

    context "there is a house number and a road" do
      it "should use both" do
        address = create(:address, building_name: "")
        phase = create(:phase, address: address)
        plot = create(:phase_plot, phase: phase, house_number: "14C", address: nil)

        expect(plot.to_homeowner_s).to eq "14C #{address.road_name}"
      end
    end

    context "there is a house number and a building and a road" do
      it "should use house number and building" do
        address = create(:address)
        phase = create(:phase, address: address)
        plot = create(:phase_plot, phase: phase, house_number: "14C", address: nil)

        expect(plot.to_homeowner_s).to eq "14C #{address.building_name}"
      end
    end

    context "there is no house number or address" do
      it "should use the plot id" do
        plot = create(:phase_plot, address: nil)

        expect(plot.to_homeowner_s).to eq "(#{plot.to_s})"
      end
    end

    context "there is building name but no house number" do
      it "should use the building name and plot id" do
        address = create(:address, postal_number: "")

        phase = create(:phase, address: address)
        plot = create(:phase_plot, phase: phase, address: nil)

        expect(plot.to_homeowner_s).to eq "#{address.building_name} (#{plot.to_s})"
      end
    end

    context "there is road name but no house number" do
      it "should use the building name and plot id" do
        address = create(:address, building_name: nil, postal_number: nil)
        phase = create(:phase, address: address)
        plot = create(:phase_plot, phase: phase, address: nil)

        expect(plot.to_homeowner_s).to eq "#{address.road_name} (#{plot.to_s})"
      end
    end

  end
end
