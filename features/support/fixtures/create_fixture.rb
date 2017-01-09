# frozen_string_literal: true
module CreateFixture
  module_function

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def create_developer_with_division
    developer = FactoryGirl.create(:developer, company_name: developer_name)
    FactoryGirl.create(:division, developer: developer, division_name: division_name)
  end

  def create_developer_with_development
    FactoryGirl.create(
      :development,
      developer: create_developer,
      name: development_name
    )
  end

  def create_unit_type
    FactoryGirl.create(
      :unit_type,
      name: unit_type_name,
      development: create_developer_with_development
    )
  end

  def create_room
    FactoryGirl.create(
      :room,
      name: room_name,
      unit_type: create_unit_type
    )
  end

  def create_appliance
    FactoryGirl.create(
      :appliance,
      name: appliance_name
    )
  end

  def developer_name
    "Development Developer Ltd"
  end

  def developer_id
    Developer.find_by(company_name: developer_name).id
  end

  def division_name
    "Alpha Division"
  end

  def division_id
    Division.find_by(division_name: division_name).id
  end

  def development_name
    "Riverside Development"
  end

  def development_id
    Development.find_by(name: development_name).id
  end

  def phase_name
    "Phase Alpha"
  end

  def unit_type_name
    "Alpha"
  end

  def room_name
    "Living Room"
  end

  def appliance_name
    "Bosch WAB28161GB Washing Machine"
  end
end
