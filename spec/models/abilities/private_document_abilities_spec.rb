# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Private document abilities" do
  subject { Ability.new(current_user) }
  let(:developer) { create(:developer) }

  describe "private documents" do
    context "As a developer admin" do
      specify "can not manage private documents even from developer plots" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident)

        developer_admin = create(:developer_admin, permission_level: developer)
        ability = Ability.new(developer_admin)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end

      specify "can not manage private documents even from phase plots" do
        development = create(:development, developer: developer)
        phase = create(:phase, development: development)
        plot = create(:plot, phase: phase)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident)

        developer_admin = create(:developer_admin, permission_level: developer)
        ability = Ability.new(developer_admin)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end
    end

    context "As a division admin" do
      specify "can not manage plot documents even from division plots" do
        division = create(:division, developer: developer)
        division_development = create(:division_development, division: division)
        plot = create(:plot, development: division_development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident)

        division_admin = create(:division_admin, permission_level: plot.division)
        ability = Ability.new(division_admin)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end
    end

    context "As a development admin" do
      specify "can not manage plot documents even from development plots" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident)

        development_admin = create(:developer_admin, permission_level: development)
        ability = Ability.new(development_admin)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end
    end

    context "As a resident" do
      specify "can manage my own documents" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident)

        ability = Ability.new(resident)

        expect(ability).to be_able_to(:manage, private_document)
      end

      specify "can not manage documents for another resident" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident)

        other_resident = create(:resident, plot: plot)

        ability = Ability.new(other_resident)
        expect(ability).not_to be_able_to(:manage, private_document)
      end
    end
  end
end
