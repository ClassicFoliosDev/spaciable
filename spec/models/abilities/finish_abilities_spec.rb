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
      room = create(:room, unit_type: unit_type)
      create(:finish_room, finish: finish, room: room)

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "can read finishes used under the developments plots" do
      development = create(:development)
      development_admin = create(:development_admin, permission_level: development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      plot = create(:plot, development: development)
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

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
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

      ability = Ability.new(development_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the development" do
      other_development = create(:development)
      development_admin = create(:development_admin, permission_level: other_development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      unit_type = create(:unit_type, development: other_development)
      room = create(:room, unit_type: unit_type)
      create(:finish_room, finish: finish, room: room)

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the developments plots" do
      other_development = create(:development)
      development_admin = create(:development_admin, permission_level: other_development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      plot = create(:plot, development: other_development)
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the developments phase plots" do
      other_development = create(:development)
      development_admin = create(:development_admin, permission_level: other_development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      phase = create(:phase, development: other_development)
      plot = create(:phase_plot, phase: phase)
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

      development_admin = create(:development_admin)
      ability = Ability.new(development_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end
  end

  context "As a site admin" do
    specify "can read finishes used under the developments unit types" do
      development = create(:development)
      site_admin = create(:site_admin, permission_level: development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      unit_type = create(:unit_type, development: development)
      room = create(:room, unit_type: unit_type)
      create(:finish_room, finish: finish, room: room)

      ability = Ability.new(site_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "can read finishes used under the developments plots" do
      development = create(:development)
      site_admin = create(:site_admin, permission_level: development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      plot = create(:plot, development: development)
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

      ability = Ability.new(site_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "can read finishes used under the developments phase plots" do
      development = create(:development)
      site_admin = create(:site_admin, permission_level: development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      phase = create(:phase, development: development)
      plot = create(:phase_plot, phase: phase)
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

      ability = Ability.new(site_admin)

      expect(ability).to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the development" do
      other_development = create(:development)
      site_admin = create(:site_admin, permission_level: other_development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      unit_type = create(:unit_type, development: other_development)
      room = create(:room, unit_type: unit_type)
      create(:finish_room, finish: finish, room: room)

      site_admin = create(:site_admin)
      ability = Ability.new(site_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the developments plots" do
      other_development = create(:development)
      site_admin = create(:site_admin, permission_level: other_development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      plot = create(:plot, development: other_development)
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

      site_admin = create(:site_admin)
      ability = Ability.new(site_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end

    specify "cannot read finishes not used under the developments phase plots" do
      other_development = create(:development)
      site_admin = create(:site_admin, permission_level: other_development)

      finish = create(:finish, name: "Test finish", finish_type: finish_type)
      phase = create(:phase, development: other_development)
      plot = create(:phase_plot, phase: phase)
      room = create(:room, plot: plot)
      create(:finish_room, finish: finish, room: room)

      site_admin = create(:site_admin)
      ability = Ability.new(site_admin)

      expect(ability).not_to be_able_to(:read, finish)
      expect(ability).not_to be_able_to(:crud, finish)
    end
  end

end
