# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlotResidency do
  describe "#create" do
    context "when the resident does not exist" do
      it "should create the resident using the provided email address" do
        email = "joe@bloggs.com"
        plot = create(:plot)

        expect { PlotResidency.create!(plot: plot, email: email, first_name: "Joe", last_name: "Bloggs") }
          .to change(Resident, :count).by(1)

        expect(Resident.find_by(email: email)).not_to be_nil
      end
    end

    context "when the resident exists" do
      it "should assign the existing resident using the provided email address" do
        resident = create(:resident, first_name: "Joe", last_name: "Doe")
        plot = create(:plot)

        expect do
          PlotResidency.create!(
            plot: plot,
            email: resident.email,
            first_name: "",
            last_name: "Bloggs"
          )
        end.not_to change(Resident, :count)

        resident.reload
        expect(resident.plot_residencies.first.plot).to eq(plot)
        expect(resident.first_name).to eq("Joe")
        expect(resident.last_name).to eq("Bloggs")
      end
    end

    it "cannot assign a resident that already has a residency for the same plot" do
      resident = create(:resident, :with_residency)
      plot = resident.plot_residencies.first.plot

      residency = PlotResidency.create(plot: plot, email: resident.email)

      error = I18n.t("activerecord.errors.messages.taken")
      expect(residency.errors[:resident]).to include(error)
    end

    it "can assign a a resident to multiple plots in the same development" do
      resident = create(:resident, :with_residency)
      development = resident.plot_residencies.first.plot.development

      plot2 = create(:plot, development: development)
      residency2 = PlotResidency.create(plot: plot2, email: resident.email)

      expect(residency2).to be_valid
      expect(plot2.residents.first.email).to eq resident.email

      plot3 = create(:plot, development: development)
      residency3 = PlotResidency.create(plot: plot3, email: resident.email)
      expect(plot3.residents.first.email).to eq resident.email

      expect(residency3).to be_valid
      expect(resident.reload.plot_residencies.count).to eq 3
      expect(resident.plots).to match_array [resident.plot_residencies.first.plot, plot2, plot3]
    end
  end

  describe "#update" do
    it "should update the resident details" do
      updated_attrs = {
        title: :mr, first_name: "John", last_name: "Bloggs"
      }
      resident = create(:resident, :with_residency)

      expect do
        resident.update(updated_attrs)
      end.not_to change(Resident, :count)
      resident.reload

      expect(resident.title).to eq(updated_attrs[:title].to_s)
      expect(resident.first_name).to eq(updated_attrs[:first_name])
      expect(resident.last_name).to eq(updated_attrs[:last_name])
    end
  end
end
