# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResidentServicesService do
  let(:plot) { create(:plot) }
  let(:resident1) { create(:resident, :activated ) }
  let(:resident2) { create(:resident, :activated ) }
  let(:plot_residency1) { create(:plot_residency, plot_id: plot.id, resident_id: resident1.id) }
  let(:plot_residency2) { create(:plot_residency, plot_id: plot.id, resident_id: resident2.id) }

  context "when there are multiple residents" do
    it "resets all the residents for a plot" do
      plot_residency1
      plot_residency2

      expect(resident1.developer_email_updates).to be_truthy
      expect(resident2.developer_email_updates).to be_truthy
      ResidentResetService.reset_all_residents_for_plot(plot)

      resident1.reload
      resident2.reload
      expect(resident1.developer_email_updates).to be_zero
      expect(resident2.developer_email_updates).to be_zero
    end
  end
end
