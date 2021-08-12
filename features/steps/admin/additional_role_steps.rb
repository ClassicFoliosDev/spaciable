# frozen_string_literal: true

Given(/^I have alternative (.*) roles$/) do |role|
  developer = CreateFixture.create_developer(name: AdditionalRoleFixture::ADDITIONAL)
  division = Division.create(division_name: AdditionalRoleFixture::ADDITIONAL, developer: developer)
  div_development = Development.create(name: AdditionalRoleFixture::ADDITIONAL, division: division, developer: developer)
  div_development_phase = Phase.create(name: AdditionalRoleFixture::ADDITIONAL, development: div_development)
  unit_type = UnitType.create(name: AdditionalRoleFixture::ADDITIONAL, developer_id: developer.id, development_id: div_development.id)
  plot = Plot.create(number: AdditionalRoleFixture::ADDITIONAL, phase: div_development_phase, unit_type: unit_type)
  resident = Resident.create(first_name: "p", last_name: "otter", email: AdditionalRoleFixture::EMAIL, developer_email_updates: true, password: "password", phone_number: "07555 555555")
  plot_residency = PlotResidency.create(resident: resident, plot: plot)
  dev_development = Development.create(name: AdditionalRoleFixture::ADDITIONAL, developer: developer)

  case role
  when "Developer Admin"
    grant = Grant.new(role: :developer_admin, permission_level_type: "Developer", permission_level_id: developer.id)
  when "Division Admin"
    grant = Grant.new(role: :division_admin, permission_level_type: "Division", permission_level_id: division.id)
  when "Development Admin"
    grant = Grant.new(role: :development_admin, permission_level_type: "Development", permission_level_id: development.id)
  end

  grant.user_id = User.first.id
  grant.save()
end
