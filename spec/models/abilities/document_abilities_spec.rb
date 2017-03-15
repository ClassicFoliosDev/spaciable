# frozen_string_literal: true
require "rails_helper"
require "cancan/matchers"

RSpec.describe "Document Abilities" do
  subject { Ability.new(current_user) }

  it_behaves_like "it has cascading polymorphic abilities", Document

  describe "plot documents" do
    context "As a developer admin" do
      specify "can manage plot documents under the developer" do
        plot = create(:plot)
        document = build(:document, documentable: plot)

        developer_admin = create(:developer_admin, permission_level: plot.developer)
        ability = Ability.new(developer_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage plot documents under another developer" do
        plot = create(:plot)
        document = build(:document, documentable: plot)

        developer_admin = create(:developer_admin)
        ability = Ability.new(developer_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end

    context "As a division admin" do
      specify "can manage plot documents under the division" do
        division_development = create(:division_development)
        plot = create(:plot, development: division_development)
        document = build(:document, documentable: plot)

        division_admin = create(:division_admin, permission_level: plot.division)
        ability = Ability.new(division_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage plot documents under another division" do
        division_development = create(:division_development)
        plot = create(:plot, development: division_development)
        document = build(:document, documentable: plot)

        division_admin = create(:division_admin)
        ability = Ability.new(division_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end

    context "As a development admin" do
      specify "can manage plot documents under the development" do
        plot = create(:plot)
        document = build(:document, documentable: plot)

        development_admin = create(:development_admin, permission_level: plot.development)
        ability = Ability.new(development_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage plot documents under another development" do
        plot = create(:plot)
        document = build(:document, documentable: plot)

        development_admin = create(:development_admin)
        ability = Ability.new(development_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end
  end

  describe "unit_type documents" do
    context "As a developer admin" do
      specify "can manage unit_type under the developer" do
        unit_type = create(:unit_type)
        document = build(:document, documentable: unit_type)

        developer_admin = create(:developer_admin, permission_level: unit_type.developer)
        ability = Ability.new(developer_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage unit_types under another developer" do
        unit_type = create(:unit_type)
        document = build(:document, documentable: unit_type)

        developer_admin = create(:developer_admin)
        ability = Ability.new(developer_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end

    context "As a division admin" do
      specify "can manage unit_type under the division" do
        division_development = create(:division_development)
        unit_type = create(:unit_type, development: division_development)
        document = build(:document, documentable: unit_type)

        division_admin = create(:division_admin, permission_level: unit_type.division)
        ability = Ability.new(division_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage unit_types under another division" do
        division_development = create(:division_development)
        unit_type = create(:unit_type, development: division_development)
        document = build(:document, documentable: unit_type)

        division_admin = create(:division_admin)
        ability = Ability.new(division_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end

    context "As a development admin" do
      specify "can manage unit_type under the development" do
        unit_type = create(:unit_type)
        document = build(:document, documentable: unit_type)

        development_admin = create(:development_admin, permission_level: unit_type.development)
        ability = Ability.new(development_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage unit_types under another development" do
        unit_type = create(:unit_type)
        document = build(:document, documentable: unit_type)

        development_admin = create(:development_admin)
        ability = Ability.new(development_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end
  end

  describe "phase documents" do
    context "As a developer admin" do
      specify "can manage phase under the developer" do
        phase = create(:phase)
        document = build(:document, documentable: phase)

        developer_admin = create(:developer_admin, permission_level: phase.developer)
        ability = Ability.new(developer_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage phases under another developer" do
        phase = create(:phase)
        document = build(:document, documentable: phase)

        developer_admin = create(:developer_admin)
        ability = Ability.new(developer_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end

    context "As a division admin" do
      specify "can manage phase under the division" do
        division_development = create(:division_development)
        phase = create(:phase, development: division_development)
        document = build(:document, documentable: phase)

        division_admin = create(:division_admin, permission_level: phase.division)
        ability = Ability.new(division_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage phases under another division" do
        division_development = create(:division_development)
        phase = create(:phase, development: division_development)
        document = build(:document, documentable: phase)

        division_admin = create(:division_admin)
        ability = Ability.new(division_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end

    context "As a development admin" do
      specify "can manage phase under the development" do
        phase = create(:phase)
        document = build(:document, documentable: phase)

        development_admin = create(:development_admin, permission_level: phase.development)
        ability = Ability.new(development_admin)

        expect(ability).to be_able_to(:manage, document)
      end

      specify "cannot manage phases under another development" do
        phase = create(:phase)
        document = build(:document, documentable: phase)

        development_admin = create(:development_admin)
        ability = Ability.new(development_admin)

        expect(ability).not_to be_able_to(:manage, document)
      end
    end
  end
end
