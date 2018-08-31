# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResidentsController do
  describe "#destroy" do
    context "as a site admin" do
      let(:development) { create(:development) }
      let(:site_admin) { create(:site_admin, development_id: development.id) }
      let(:phase) { create(:phase, development: development) }
      let(:plot) { create(:plot, phase: phase) }
      let(:other_plot) { create(:plot, phase: phase) }

      context "when there are homeowners and tenants" do
        let(:tenant) { create(:resident, email: "tenant@example.com") }
        let(:tenant_residency) { create(:plot_residency, plot_id: plot.id, resident_id: tenant.id, role: :tenant) }
        let(:legacy_resident) { create(:resident, email: "legacy@example.com") }
        let(:legacy_residency) { create(:plot_residency, plot_id: plot.id, resident_id: legacy_resident.id) }
        let(:homeowner) { create(:resident, email: "homeowner@example.com") }
        let(:homeowner_residency) { create(:plot_residency, plot_id: plot.id, resident_id: homeowner.id, role: :homeowner) }
        let(:tenant_with_other_residency) { create(:resident, email: "tenant_also_homeowner@example.com") }
        let(:other_tenant_residency) { create(:plot_residency, plot_id: plot.id, resident_id: tenant_with_other_residency.id, role: :tenant) }
        let(:other_tenant_homeowner_residency) { create(:plot_residency, plot_id: other_plot.id, resident_id: tenant_with_other_residency.id, role: :homeowner) }

        scenario "when I delete a homeowner, no other residents are deleted" do
          tenant_residency
          legacy_residency
          homeowner_residency
          other_tenant_residency
          other_tenant_homeowner_residency

          login_as site_admin

          expect(PlotResidency.count).to eq 5
          expect(Resident.count).to eq 4

          url = "/plots/#{plot.id}/residents/#{homeowner.id}"
          delete url

          expect(PlotResidency.count).to eq 4
          PlotResidency.all.each do |residency|
            expect(residency.resident).not_to eq homeowner
          end

          expect(Resident.count).to eq 3
          Resident.all.each do |resident|
            expect(resident).not_to eq homeowner
          end
        end

        scenario "when I delete the last homeowner, the tenant is also removed" do
          tenant_residency
          legacy_residency
          homeowner_residency
          other_tenant_residency
          other_tenant_homeowner_residency

          login_as site_admin

          expect(PlotResidency.count).to eq 5
          expect(Resident.count).to eq 4

          url = "/plots/#{plot.id}/residents/#{homeowner.id}"
          delete url

          url2 = "/plots/#{plot.id}/residents/#{legacy_resident.id}"
          delete url2

          expect(PlotResidency.count).to eq 1
          expect(PlotResidency.first).to eq other_tenant_homeowner_residency

          expect(Resident.count).to eq 1
          expect(Resident.first).to eq tenant_with_other_residency
        end

        scenario "when I delete the last tenant, no other residents are deleted" do
          tenant_residency
          legacy_residency
          homeowner_residency
          other_tenant_residency
          other_tenant_homeowner_residency

          login_as site_admin

          expect(PlotResidency.count).to eq 5
          expect(Resident.count).to eq 4

          url = "/plots/#{plot.id}/residents/#{tenant_with_other_residency.id}"
          delete url

          url2 = "/plots/#{plot.id}/residents/#{tenant.id}"
          delete url2

          expect(PlotResidency.count).to eq 3
          PlotResidency.all.each do |residency|
            expect(residency.resident).not_to eq tenant
          end

          expect(Resident.count).to eq 3
          Resident.all.each do |resident|
            expect(resident).not_to eq tenant
          end
        end
      end
    end
  end
end
