# frozen_string_literal: true

require "rails_helper"
RSpec.describe Csv::DeveloperCsvService do
  let(:developer) { create(:developer) }
  let(:division) { create(:division, developer: developer) }
  let(:development) { create(:development, developer: developer) }
  # If developer not set to nil, the create factory builds and assigns another (different) developer
  let(:division_development) { create(:development, division: division, developer: nil) }
  let(:plot_a) { create(:plot, development: development, developer: developer) }
  let(:resident_a) { create(:resident) }
  let(:plot_resident_a) { create(:plot_residency, resident: resident_a, plot: plot_a) }
  let(:plot_b) { create(:plot, development: development, developer: developer) }
  let(:resident_b) { create(:resident) }
  let(:plot_resident_b) { create(:plot_residency, resident: resident_b, plot: plot_b) }
  let(:plot_d) { create(:plot, development: division_development, developer: developer) }
  let(:resident_d) { create(:resident) }
  let(:plot_resident_d) { create(:plot_residency, resident: resident_d, plot: plot_d) }

  context "start and end date for report" do
    it "only shows residents within dates" do
      start_date = Time.zone.now.ago(1.month).to_date
      end_date = Time.zone.now.to_date
      plot_c = Plot.create(development: division_development, 
                           developer: developer,
                           created_at: Time.zone.now.ago(2.months))

      resident_e = Resident.create(created_at: Time.zone.now.ago(2.months),
                                   email: "resident@before_csv_date",
                                   first_name: "Early",
                                   last_name: "Resident",
                                   phone_number: "02380 123456",
                                   password: "Passw0rd")
      plot_d.residents << resident_e
      plot_resident_a
      plot_resident_b
      plot_resident_d

      report = Report.new(report_from: start_date, report_to: end_date, developer_id: developer.id)
      result = described_class.call(report)

      csv = CSV.read(result, headers: true)

      expect(csv.length).to eq 3
     
      formatted_from = I18n.l(start_date.to_date, format: :digits)
      formatted_to = I18n.l(end_date.to_date, format: :digits)
      between_dates = "between #{formatted_from} and #{formatted_to}"

      development_row = csv[0]
      expect(development_row["Plots created #{between_dates}"]).to eq "2"
      expect(development_row["Residents invited #{between_dates}"]).to eq "2"

      division_row = csv[1]
      expect(division_row["Plots created #{between_dates}"]).to eq "3"
      expect(division_row["Residents invited #{between_dates}"]).to eq "3"

      division_development_row = csv[2]
      # Two plots: plot_c and plot_d, but only plot_d was created within the time limits
      # plot_d has two residents: resident_d and resident_e, but only resident_d was created within the time limits
      expect(division_development_row["Plots created #{between_dates}"]).to eq "1"
      expect(division_development_row["Residents invited #{between_dates}"]).to eq "1"
    end
  end
end
