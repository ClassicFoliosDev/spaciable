# frozen_string_literal: true
require "rails_helper"
require "cancan/matchers"

RSpec.describe "Appliance Abilities" do
  context "As a development admin" do
    specify "can read appliances used under the developments unit types" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      appliance = create(:appliance)
      unit_type = create(:unit_type, development: development)
      create(:room, unit_type: unit_type, appliances: [appliance])

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, appliance)
      expect(ability).not_to be_able_to(:crud, appliance)
    end

    specify "can read appliances used under the developments plots" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      appliance = create(:appliance)
      plot = create(:plot, development: development)
      create(:plot_room, plot: plot, appliances: [appliance])

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, appliance)
      expect(ability).not_to be_able_to(:crud, appliance)
    end

    specify "can read appliances used under the developments phase plots" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      appliance = create(:appliance)
      phase = create(:phase, development: development)
      plot = create(:phase_plot, phase: phase)
      create(:plot_room, plot: plot, appliances: [appliance])

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, appliance)
      expect(ability).not_to be_able_to(:crud, appliance)
    end

    specify "cannot read appliances not used under the development" do
      other_development = create(:development)

      appliance = create(:appliance)
      unit_type = create(:unit_type, development: other_development)
      create(:room, unit_type: unit_type, appliances: [appliance])

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, appliance)
      expect(ability).not_to be_able_to(:crud, appliance)
    end

    specify "cannot read appliances not used under the developments plots" do
      other_development = create(:development)

      appliance = create(:appliance)
      plot = create(:plot, development: other_development)
      create(:plot_room, plot: plot, appliances: [appliance])

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, appliance)
      expect(ability).not_to be_able_to(:crud, appliance)
    end

    specify "cannot read appliances not used under the developments phase plots" do
      other_development = create(:development)

      appliance = create(:appliance)
      phase = create(:phase, development: other_development)
      plot = create(:phase_plot, phase: phase)
      create(:plot_room, plot: plot, appliances: [appliance])

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, appliance)
      expect(ability).not_to be_able_to(:crud, appliance)
    end
  end
end
