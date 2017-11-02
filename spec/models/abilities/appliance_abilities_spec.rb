# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Appliance Abilities" do
  context "As a developer admin" do
    specify "can read appliances used under the developer's developments unit types" do
      developer = create(:developer)
      other_developer = create(:developer)
      developer_admin = create(:developer_admin, permission_level: developer)
      division = create(:division, developer: developer)
      development1 = create(:development, developer: developer)
      development2 = create(:development, developer: other_developer)
      development3 = create(:development, developer: developer, division: division)

      appliance = create(:appliance)
      appliance2 = create(:appliance)
      unit_type = create(:unit_type, development: development1)
      create(:room, unit_type: unit_type, appliances: [appliance, appliance2])

      ability = Ability.new(developer_admin)

      unit_type_a = create(:unit_type, development: development2)
      create(:room, unit_type: unit_type_a, appliances: [appliance, appliance2])

      appliance3 = create(:appliance)
      appliance4 = create(:appliance)
      unit_type_b = create(:unit_type, development: development3)
      create(:room, unit_type: unit_type_b, appliances: [appliance3, appliance4])

      expect(ability).to be_able_to(:read, appliance)
      expect(ability).to be_able_to(:read, appliance2)
      expect(ability).to be_able_to(:read, appliance3)
      expect(ability).to be_able_to(:read, appliance4)
      expect(ability).not_to be_able_to(:crud, appliance)
    end
  end

  context "As a development admin" do
    specify "can read appliances used under the developments unit types" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      appliance = create(:appliance)
      appliance2 = create(:appliance)
      unit_type = create(:unit_type, development: development)
      create(:room, unit_type: unit_type, appliances: [appliance, appliance2])

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, appliance)
      expect(ability).to be_able_to(:read, appliance2)
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
