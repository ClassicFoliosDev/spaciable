# frozen_string_literal: true

require "rails_helper"
RSpec.describe Csv::DevelopmentCsvService do
  let(:developer) { create(:developer) }
  let(:development) { create(:development, developer: developer) }
  let(:phase) { create(:phase, development: development, name: "A") }
  let(:plot_a) { create(:plot, phase: phase, development: development, developer: developer, prefix: "Plot", number: "A") }
  let(:resident_a) { create(:resident) }
  let(:plot_resident_a) { create(:plot_residency, resident: resident_a, plot: plot_a, role: 0) }
  let(:plot_b) { create(:plot, phase: phase, development: development, developer: developer, prefix: "Plot", number: "B") }
  let(:resident_b) { create(:resident) }
  let(:plot_resident_b) { create(:plot_residency, resident: resident_b, plot: plot_b, role: 1) }
  let(:plot_c) { create(:plot, phase: phase, development: development, developer: developer, prefix: "Plot", number: "10") }
  let(:plot_d) { create(:plot, phase: phase, development: development, developer: developer, prefix: "Plot", number: "9") }

  context "plot with alphanumeric number" do
    it "creates the csv correctly" do
      plot_resident_a
      plot_resident_b
      plot_c.update_attributes(completion_release_date: Time.zone.now, extended_access: 2)
      plot_d  
      start_date = Time.zone.now.ago(1.month).to_date
      end_date = Time.zone.now.to_date   

      report = Report.new(report_from: start_date, report_to: end_date, development_id: development.id)
      result = described_class.call(report)
  
      csv = CSV.read(result, headers: true)
  
      expect(csv.length).to eq 5

      expect(csv[0]["Development name"]).to eq development.name
      expect(csv[1]["Development name"]).to eq ""
      expect(csv[1]["Plot number"]).to eq plot_a.to_s
      expect(csv[1]["Resident role"]).to eq "Tenant"

      expect(csv[2]["Plot number"]).to eq plot_b.to_s
      expect(csv[2]["Resident role"]).to eq "Homeowner"

      expect(csv[3]["Plot number"]).to eq plot_d.to_s
      expect(csv[4]["Plot number"]).to eq plot_c.to_s

      expiry_date = Time.zone.today.advance(months: 29).to_s
      expect(csv[4]["Expiry date"]).to eq expiry_date
    end
  end
end

