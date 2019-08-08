# frozen_string_literal: true

module LettingsFixture
  module_function

  def create_unletable_plot
    phase = Phase.find_by(name: HomeownerUserFixture.phase_name)
    plot = FactoryGirl.create(:phase_plot, number: plot_number, phase_id: phase.id, prefix: "Flat", letable: false)
    resident = Resident.find_by(email: HomeownerUserFixture.email)
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :homeowner)
  end


  def plot_number
    "221B"
  end
end
