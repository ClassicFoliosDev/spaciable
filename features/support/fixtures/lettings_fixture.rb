# frozen_string_literal: true

module LettingsFixture
  module_function

  def create_unletable_plot
    phase = Phase.find_by(name: HomeownerUserFixture.phase_name)
    plot = FactoryGirl.create(:phase_plot, number: unletable_plot_number,
                              phase_id: phase.id, prefix: "Flat", letable: false)
    resident = Resident.find_by(email: HomeownerUserFixture.email)
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :homeowner)
  end

  def create_letable_plot
    phase = Phase.find_by(name: HomeownerUserFixture.phase_name)
    plot = FactoryGirl.create(:phase_plot, number: letable_plot_number, phase_id: phase.id,
                              prefix: "Flat", letable: true, letable_type: 'planet_rent',
                              letter_type: 'homeowner')
    resident = Resident.find_by(email: HomeownerUserFixture.email)
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :homeowner)
  end

  def create_second_letable_plot
    phase = Phase.find_by(name: HomeownerUserFixture.phase_name)
    plot = FactoryGirl.create(:phase_plot, number: second_letable_plot_number, phase_id: phase.id,
                              prefix: "Flat", letable: true, letable_type: 'planet_rent',
                              letter_type: 'homeowner')
    resident = Resident.find_by(email: HomeownerUserFixture.email)
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :homeowner)
  end

  def create_second_resident
    FactoryGirl.create(:resident, email: second_resident_email, password: second_resident_password,
                       first_name: second_resident_name, last_name: second_resident_surname)
    plot = Plot.find_by(number: letable_plot_number)
    resident = Resident.find_by(email: second_resident_email)
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :homeowner)
  end

  def unletable_plot_number
    "221B"
  end

  def letable_plot_number
    "37A"
  end

  def second_letable_plot_number
    "63"
  end

  def pets_policy
    "All the pets"
  end

  def property_summary
    "Is very good"
  end

  def key_features
    "river in garden"
  end

  def second_resident_email
    "second@email.com"
  end

  def second_resident_password
    "12345678"
  end

  def second_resident_name
    "Sherlock"
  end

  def second_resident_surname
    "Holmes"
  end
end
