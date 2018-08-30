# frozen_string_literal: true

require "rails_helper"

RSpec.describe Homeowners::ResidentsController do
  describe "#remove_resident" do
    context "as a homeowner" do
      let(:plot) { create(:plot) }
      let(:homeowner) { create(:resident, :activated) }
      let(:plot_residency) { create(:plot_residency, plot_id: plot.id, resident_id: homeowner.id, role: :homeowner) }

      context "when there are residents with multiple plots" do
        let (:tenant_who_owns_another_plot) { create(:resident, :activated) }
        let (:tenant_residency) { create(:plot_residency, plot_id: plot.id, invited_by: homeowner, resident_id: tenant_who_owns_another_plot.id, role: :tenant) }
        let (:other_plot) { create(:plot) }
        let (:other_plot_residency) { create(:plot_residency, plot_id: other_plot.id, resident_id: tenant_who_owns_another_plot.id, role: :homeowner) }

        it "can remove the homeowners I created" do
          plot_residency
          tenant_residency
          other_plot_residency

          login_as homeowner
          expect(PlotResidency.all.count).to eq 3

          url = "/homeowners/remove_resident?email=#{tenant_who_owns_another_plot.email}"
          get url

          expect(response.status).to eq(200)

          expect(PlotResidency.all.count).to eq 2
          PlotResidency.all.each do |residency|
            if residency.plot_id == plot.id
              expect(residency.resident_id).to eq homeowner.id
              expect(residency.role).to eq "homeowner"
            elsif residency.plot_id == other_plot.id
              expect(residency.resident_id).to eq tenant_who_owns_another_plot.id
              expect(residency.role).to eq "homeowner"
            end
          end
        end
      end

      context "when there are multiple homeowners" do
        let(:second_homeowner) { create(:resident, :activated) }
        let(:second_plot_residency) { create(:plot_residency, plot_id: plot.id, resident_id: second_homeowner.id, role: :homeowner) }

        let(:third_homeowner) { create(:resident, :activated) }
        let(:third_plot_residency) { create(:plot_residency, plot_id: plot.id, resident_id: third_homeowner.id, role: :homeowner, invited_by: second_homeowner) }

        it "can not remove homeowners created by another homeowner" do
          plot_residency
          second_plot_residency
          third_plot_residency

          login_as homeowner
          expect(PlotResidency.all.count).to eq 3

          url = "/homeowners/remove_resident?email=#{third_homeowner.email}"
          get url

          expect(response.status).to eq(401)
        end
      end
    end
  end
end
