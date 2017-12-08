# frozen_string_literal: true

module HomeownerUserFixture
  module_function

  def create
    developer = FactoryGirl.create(:developer)
    division = FactoryGirl.create(:division, developer_id: developer.id)
    development = FactoryGirl.create(:development, division_id: division.id)
    phase = FactoryGirl.create(:phase, development_id: development.id)
    plot = FactoryGirl.create(:plot, phase_id: phase.id)

    FactoryGirl.create(
      :resident,
      :with_residency,
      email: email,
      password: password,
      first_name: first_name,
      plot: plot
    )
  end

  def create_without_residency
    FactoryGirl.create(
      :resident,
      email: email,
      password: password,
      first_name: first_name
    )
  end

  def email
    "homeowner@example.com"
  end

  def password
    "87654321"
  end

  def first_name
    "Jonathan"
  end

  def updated_password
    "foo54321"
  end
end
