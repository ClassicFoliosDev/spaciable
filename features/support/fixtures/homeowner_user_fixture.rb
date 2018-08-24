# frozen_string_literal: true

module HomeownerUserFixture
  module_function

  def create
    developer = FactoryGirl.create(:developer, company_name: developer_name)
    division = FactoryGirl.create(:division, division_name: division_name, developer_id: developer.id)
    development = FactoryGirl.create(:development, name: development_name, division_id: division.id, developer_id: developer.id)
    phase = FactoryGirl.create(:phase, name: phase_name, development_id: development.id)
    plot = FactoryGirl.create(:phase_plot, number: plot_number, phase_id: phase.id)

    resident = create_without_residency
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id, role: :homeowner)

    resident
  end

  def create_without_residency
    FactoryGirl.create(
      :resident,
      email: email,
      password: password,
      first_name: first_name,
      ts_and_cs_accepted_at: Time.zone.now,
      phone_number: phone_num
    )
  end

  def create_more_plot_residencies
    phase = Phase.find_by(name: phase_name)
    second_plot = FactoryGirl.create(:plot, phase_id: phase.id)
    resident = Resident.find_by(email: email)
    FactoryGirl.create(:plot_residency, plot_id: second_plot.id, resident_id: resident.id)

    division = Division.find_by(division_name: division_name)
    second_development = FactoryGirl.create(:development, division_id: division.id)
    second_phase =  FactoryGirl.create(:phase, development_id: second_development.id)
    second_development_plot = FactoryGirl.create(:plot, phase_id: second_phase.id)
    FactoryGirl.create(:plot_residency, plot_id: second_development_plot.id, resident_id: resident.id)

    developer = Developer.find_by(company_name: developer_name)
    second_division = FactoryGirl.create(:division, developer_id: developer.id)
    second_division_development = FactoryGirl.create(:development, division_id: second_division.id)
    second_division_development_phase = FactoryGirl.create(:phase, development_id: second_division_development.id)
    second_division_development_plot = FactoryGirl.create(:plot, phase_id: second_division_development_phase.id)
    FactoryGirl.create(:plot_residency, plot_id: second_division_development_plot.id, resident_id: resident.id)

    second_developer = FactoryGirl.create(:developer)
    second_developer_development = FactoryGirl.create(:development, developer_id: second_developer.id)
    second_developer_development_phase = FactoryGirl.create(:phase, development_id: second_developer_development.id)
    second_developer_development_plot = FactoryGirl.create(:plot, phase_id: second_developer_development_phase.id)
    FactoryGirl.create(:plot_residency, plot_id: second_developer_development_plot.id, resident_id: resident.id)
  end

  def email
    "homeowner@example.com"
  end

  def password
    "87654321"
  end

  # https://fakenumber.org/united-kingdom
  def phone_num
    "020 7925 0918"
  end

  def phase_name
    "First phase"
  end

  def division_name
    "First division"
  end

  def developer_name
    "First developer"
  end

  def development_name
    "First development"
  end

  def first_name
    "Jonathan"
  end

  def updated_password
    "foo54321"
  end

  def plot_number
    "63B"
  end
end
