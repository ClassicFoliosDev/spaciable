# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Finish Abilities" do
  let(:finish_category) { create(:finish_category, name: "Test category") }
  let(:finish_type) { create(:finish_type, name: "Test type", finish_categories: [finish_category]) }

  context "As a development admin" do
    specify "can read finishes used under the developments unit types" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      unit_type = create(:unit_type, development: development)
      create(:room, unit_type: unit_type, finishes: [finish])

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "can read finishes used under the developments plots" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      plot = create(:plot, development: development)
      create(:plot_room, plot: plot, finishes: [finish])

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "can read finishes used under the developments phase plots" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      phase = create(:phase, development: development)
      plot = create(:phase_plot, phase: phase)
      create(:plot_room, plot: plot, finishes: [finish])

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the development" do
      other_development = create(:development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      unit_type = create(:unit_type, development: other_development)
      create(:room, unit_type: unit_type, finishes: [finish])

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the developments plots" do
      other_development = create(:development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      plot = create(:plot, development: other_development)
      create(:plot_room, plot: plot, finishes: [finish])

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the developments phase plots" do
      other_development = create(:development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      phase = create(:phase, development: other_development)
      plot = create(:phase_plot, phase: phase)
      create(:plot_room, plot: plot, finishes: [finish])

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end
  end
end
