# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Plot Abilities" do
  context "As a development admin" do
    specify "can read plots under the development" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      plot = create(:plot, development: development)
      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, plot)
      # Development admin needs edit ability on plots, so that they can update the progress
      # and completion date.
      # They should not be able to edit other fields, this is limited in the controller
      expect(ability).to be_able_to(:edit, plot)
      expect(ability).to be_able_to(:update, plot)
      expect(ability).not_to be_able_to(:delete, plot)
      expect(ability).not_to be_able_to(:create, plot)
    end

    specify "can read plots under the development phase" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      phase = create(:phase, development: development)
      plot = create(:phase_plot, phase: phase)

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, plot)
      expect(ability).not_to be_able_to(:crud, plot)
    end

    specify "cannot read plots from other developments" do
      other_development = create(:development)

      unit_type = create(:unit_type, development: other_development)
      plot = create(:plot, unit_type: unit_type, development: other_development)

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, plot)
      expect(ability).not_to be_able_to(:crud, plot)
    end

    specify "can add residents to a development plot" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      plot = create(:plot, development: development)
      resident = create(:resident)
      plot_resident = create(:plot_residency, plot: plot, resident: resident)

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:create, resident)
      expect(ability).to be_able_to(:crud, plot_resident)
    end

    specify "can not clone a unit type" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)
      unit_type = create(:unit_type, development: development)

      ability = Ability.new(development_admin)
      expect(ability).not_to be_able_to(:clone, unit_type)
    end
  end

  context "As a division admin" do
    specify "can read plots under the division" do
      division = create(:division)
      development = create(:development, division: division)
      division_admin = create(:division_admin, permission_level: division)

      plot = create(:plot, development: development)

      ability = Ability.new(division_admin)

      expect(ability).to be_able_to(:read, plot)
      expect(ability).not_to be_able_to(:crud, plot)
    end

    specify "cannot read plots from other divisions" do
      division = create(:division)
      other_division = create(:division)
      other_development = create(:development, division: other_division)

      unit_type = create(:unit_type, development: other_development)
      plot = create(:plot, unit_type: unit_type, development: other_development)

      division_admin = create(:division_admin, permission_level: division)
      ability = Ability.new(division_admin)

      expect(ability).not_to be_able_to(:read, plot)
      expect(ability).not_to be_able_to(:crud, plot)
    end

    specify "can add residents to a division plot" do
      division = create(:division)
      development = create(:development, division: division)
      division_admin = create(:division_admin, permission_level: division)

      plot = create(:plot, development: development)
      resident = create(:resident)
      plot_resident = create(:plot_residency, plot: plot, resident: resident)

      ability = Ability.new(division_admin)

      expect(ability).to be_able_to(:create, resident)
      expect(ability).to be_able_to(:crud, plot_resident)
    end
  end

  context "As a developer admin" do
    specify "can read plots under the developer" do
      developer = create(:developer)
      development = create(:development, developer: developer)
      developer_admin = create(:developer_admin, permission_level: developer)

      plot = create(:plot, development: development)

      ability = Ability.new(developer_admin)

      expect(ability).to be_able_to(:read, plot)
      expect(ability).not_to be_able_to(:crud, plot)
    end

    specify "cannot read plots from other developers" do
      developer = create(:developer)
      other_developer = create(:developer)
      other_development = create(:development, developer: other_developer)

      unit_type = create(:unit_type, development: other_development)
      plot = create(:plot, unit_type: unit_type, development: other_development)

      developer_admin = create(:developer_admin, permission_level: developer)
      ability = Ability.new(developer_admin)

      expect(ability).not_to be_able_to(:read, plot)
      expect(ability).not_to be_able_to(:crud, plot)
    end

    specify "can add residents to a developer plot" do
      developer = create(:developer)
      development = create(:development, developer: developer)
      developer_admin = create(:developer_admin, permission_level: developer)

      plot = create(:plot, development: development)
      resident = create(:resident)
      plot_resident = create(:plot_residency, plot: plot, resident: resident)

      ability = Ability.new(developer_admin)

      expect(ability).to be_able_to(:create, resident)
      expect(ability).to be_able_to(:crud, plot_resident)
    end
  end

  context "As a site admin" do
    specify "can read plots under the development" do
      development = create(:development)
      site_admin = create(:site_admin, permission_level: development)

      plot = create(:plot, development: development)
      ability = Ability.new(site_admin)

      expect(ability).to be_able_to(:read, plot)

      expect(ability).not_to be_able_to(:create, plot)
      expect(ability).not_to be_able_to(:edit, plot)
      expect(ability).not_to be_able_to(:update, plot)
      expect(ability).not_to be_able_to(:delete, plot)
    end

    specify "can read plots under the development phase" do
      development = create(:development)
      site_admin = create(:site_admin, permission_level: development)

      phase = create(:phase, development: development)
      plot = create(:phase_plot, phase: phase)

      ability = Ability.new(site_admin)

      expect(ability).to be_able_to(:read, plot)

      expect(ability).not_to be_able_to(:create, plot)
      expect(ability).not_to be_able_to(:edit, plot)
      expect(ability).not_to be_able_to(:update, plot)
      expect(ability).not_to be_able_to(:delete, plot)
    end

    specify "cannot read plots from other developments" do
      other_development = create(:development)

      unit_type = create(:unit_type, development: other_development)
      plot = create(:plot, unit_type: unit_type, development: other_development)

      site_admin = create(:site_admin)
      ability = Ability.new(site_admin)

      expect(ability).not_to be_able_to(:read, plot)
      expect(ability).not_to be_able_to(:crud, plot)
    end

    specify "can add residents to a development plot" do
      development = create(:development)
      site_admin = create(:site_admin, permission_level: development)

      plot = create(:plot, development: development)
      resident = create(:resident)
      plot_resident = create(:plot_residency, plot: plot, resident: resident)

      ability = Ability.new(site_admin)

      expect(ability).to be_able_to(:create, resident)
      expect(ability).to be_able_to(:crud, plot_resident)
    end

    specify "can not clone a unit type" do
      development = create(:development)
      site_admin = create(:site_admin, permission_level: development)
      unit_type = create(:unit_type, development: development)

      ability = Ability.new(site_admin)
      expect(ability).not_to be_able_to(:clone, unit_type)
    end
  end
end
