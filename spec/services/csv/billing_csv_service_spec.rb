# frozen_string_literal: true

require "rails_helper"
RSpec.describe Csv::BillingCsvService do
  let(:developer) { create(:developer, company_name: "AAA developer") }
  let(:division) { create(:division) }
  let(:development) { create(:development, developer: developer) }
  let(:division_development) { create(:development, division: division, developer: division.developer) }
  let(:phase) { create(:phase, development: development, name: "A") }
  let(:division_phase) { create(:phase, development: division_development, name: "1") }
  let(:plot_a) { create(:plot, phase: division_phase, development: division_development, developer: division.developer, prefix: "Plot", number: "A") }
  let(:resident_a) { create(:resident) }
  let(:plot_resident_a) { create(:plot_residency, resident: resident_a, plot: plot_a) }
  let(:plot_b) { create(:plot, phase: phase, development: development, developer: developer, prefix: "Plot", number: "B") }
  let(:resident_b) { create(:resident, invitation_accepted_at: Time.zone.now) }
  let(:plot_resident_b) { create(:plot_residency, resident: resident_b, plot: plot_b) }
  let(:plot_c) { create(:plot, phase: phase, development: development, developer: developer, prefix: "Plot", number: "10") }
  let(:plot_d) { create(:plot, phase: division_phase, development: division_development, developer: division.developer, prefix: "Plot", number: "9", progress: 2) }
  let(:plot_e) { create(:plot, phase: division_phase, development: division_development, developer: division.developer, prefix: "Plot", number: "2") }

  context "plots" do
    it "creates the csv correctly" do
      plot_resident_a
      plot_resident_b
      plot_c.update_attributes(completion_release_date: Time.zone.now, extended_access: 2)
      plot_d
      plot_e
      start_date = Time.zone.now.ago(1.month).to_date
      end_date = Time.zone.now.to_date   

      report = Report.new(report_from: start_date, report_to: end_date)
      result = described_class.call(report)
  
      csv = CSV.read(result, headers: true)
  
      expect(csv.length).to eq 5

      expect(csv[0]["Plot"]).to eq plot_b.to_s
      expect(csv[0]["Developer"]).to eq developer.to_s
      expect(csv[0]["Division"]).to eq "N/A"
      expect(csv[0]["Development"]).to eq development.to_s
      expect(csv[0]["Residents invited"]).to eq "1"
      expect(csv[0]["Residents accepted"]).to eq "1"

      expiry_date = Time.zone.today.advance(months: 27).advance(months: 2).to_s
      expect(csv[1]["Plot"]).to eq plot_c.to_s
      expect(csv[1]["Expiry date"]).to eq expiry_date

      expect(csv[2]["Plot"]).to eq plot_a.to_s
      expect(csv[2]["Developer"]).to eq division.developer.to_s
      expect(csv[2]["Division"]).to eq division.to_s
      expect(csv[2]["Development"]).to eq division_development.to_s
      expect(csv[2]["Residents invited"]).to eq "1"
      expect(csv[2]["Residents accepted"]).to eq "0"

      expect(csv[3]["Plot"]).to eq plot_e.to_s
      expect(csv[3]["Residents invited"]).to eq "0"
      expect(csv[3]["Residents accepted"]).to eq "0"
      expect(csv[3]["Build progress"]).to eq "Building soon"

      expect(csv[4]["Plot"]).to eq plot_d.to_s
      expect(csv[4]["Expiry date"]).to be_blank
      expect(csv[4]["Build progress"]).to eq "Roof on"
   end
  end
end
