# frozen_string_literal: true

Given(/^I have alternative (.*) roles$/) do |role|
  developer = CreateFixture.create_developer(name: AdditionalRoleFixture::ADDITIONAL)

  division = Division.create(division_name: AdditionalRoleFixture::ADDITIONAL, developer: developer)
  div_development = Development.create(name: AdditionalRoleFixture::ADDITIONAL, division: division, developer: developer)
  additional_plot(developer, div_development)
  dev_development = Development.create(name: AdditionalRoleFixture::ADDITIONAL, developer: developer)

  case role
  when "Developer Admin"
    Grant.create(user: User.first, role: :developer_admin, permission_level_type: "Developer", permission_level_id: developer.id)
  when "Division Admin"
    Grant.create(user: User.first, role: :division_admin, permission_level_type: "Division", permission_level_id: division.id)
  when "Development Admin"
    Grant.create(user: User.first, role: :development_admin, permission_level_type: "Development", permission_level_id: dev_development.id)
    additional_plot(developer, dev_development)
  end
end

# add an 'additional' plot for the development
def additional_plot(developer, development)
  development_phase = Phase.create(name: AdditionalRoleFixture::ADDITIONAL, development: development)
  unit_type = UnitType.create(name: AdditionalRoleFixture::ADDITIONAL, developer_id: developer.id, development_id: development.id)
  plot = Plot.create(number: AdditionalRoleFixture::ADDITIONAL, phase: development_phase, unit_type: unit_type)
  plot_residency = PlotResidency.create(resident: additional_resident, plot: plot)
end

# all the additional tests share one resident
def additional_resident
  @resident ||= Resident.create(first_name: "p", last_name: "otter", email: AdditionalRoleFixture::EMAIL, developer_email_updates: true, password: "password", phone_number: "07555 555555")
end
