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

    context "As a site admin" do
      specify "can not manage plot documents even from development plots" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident)

        site_admin = create(:site_admin, permission_level: development)
        ability = Ability.new(site_admin)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end
    end

    context "As a homeowner resident" do
      specify "can manage my own documents" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident, plot_id: plot.id)

        ability = Ability.new(resident, plot: plot)

        expect(ability).to be_able_to(:manage, private_document)
      end

      specify "can not read or manage documents for another resident" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, :with_residency, plot: plot)
        private_document = create(:private_document, resident: resident, plot_id: plot.id)

        other_resident = create(:resident, :with_residency, plot: plot)

        ability = Ability.new(other_resident, plot)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end
    end

    context "Legacy documents" do
      specify "can manage my own documents" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        private_document = create(:private_document, resident: resident, plot_id: nil)

        ability = Ability.new(resident, plot: plot)

        expect(ability).to be_able_to(:manage, private_document)
      end

      specify "can not read documents for another resident" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, :with_residency, plot: plot)
        private_document = create(:private_document, resident: resident, plot_id: nil)

        other_resident = create(:resident, :with_residency, plot: plot)

        ability = Ability.new(other_resident, plot: plot)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end
    end

    context "As a tenant resident" do
      specify "can not view private documents" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, :with_residency, plot: plot,)
        tenant = create(:resident, :with_tenancy, plot: plot,)
        private_document = create(:private_document, resident: resident, plot_id: plot.id)

        ability = Ability.new(tenant, plot: plot)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end

      specify "can view private documents if tenant read enabled" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        create(:plot_residency, resident: resident, plot: plot, role: :homeowner)
        tenant = create(:resident, plot: plot)
        create(:plot_residency, resident: tenant, plot: plot, role: :tenant)
        private_document = create(:private_document, resident: resident, plot_id: plot.id)
        plot_private_document = create(:plot_private_document, plot: plot, private_document: private_document, enable_tenant_read: true)

        ability = Ability.new(tenant, plot: plot)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).to be_able_to(:read, private_document)
      end

      specify "can not view private documents if tenant read was previously enabled, now disabled" do
        development = create(:development, developer: developer)
        plot = create(:plot, development: development)

        resident = create(:resident, plot: plot)
        create(:plot_residency, resident: resident, plot: plot, role: :homeowner)
        tenant = create(:resident, plot: plot)
        create(:plot_residency, resident: tenant, plot: plot, role: :tenant)
        private_document = create(:private_document, resident: resident, plot_id: plot.id)
        plot_private_document = create(:plot_private_document, plot: plot, private_document: private_document, enable_tenant_read: false)

        ability = Ability.new(tenant, plot: plot)

        expect(ability).not_to be_able_to(:manage, private_document)
        expect(ability).not_to be_able_to(:read, private_document)
      end
    end
  end
end
