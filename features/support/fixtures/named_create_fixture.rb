# frozen_string_literal: true

module NamedCreateFixture
  module_function

  def create_developer
    return if developer
    country = FactoryGirl.create(:country)
    FactoryGirl.create(:developer, company_name: developer_name,
                       custom_url: developer_name.parameterize,
                       country_id: country.id)
  end

  def create_second_developer
    return if second_developer
    country = FactoryGirl.create(:country)
    FactoryGirl.create(:developer, company_name: second_developer_name,
                        custom_url: second_developer_name.parameterize,
                        country_id: country.id)
  end

  def create_division
    return if division
    FactoryGirl.create(:division, division_name: division_name, developer: developer)
  end

  def create_second_division
    return if second_division
    FactoryGirl.create(:division, division_name: second_division_name, developer: second_developer)
  end

  def create_second_division_development
    return if second_division_development
    FactoryGirl.create(:division_development, name: second_division_development_name, division: second_division)
  end

  def create_development
    return if development
    FactoryGirl.create(:development, name: development_name, developer: developer)
  end


  # ADMINS

  def create_developer_admin
    FactoryGirl.create(:developer_admin, permission_level: developer, email: developer_email)
  end

  def create_second_developer_admin
    FactoryGirl.create(:developer_admin, permission_level: second_developer, email: second_developer_email)
  end

  def create_division_admin
    FactoryGirl.create(:division_admin, permission_level: division, email: division_email)
  end

  def create_second_division_development_admin
    FactoryGirl.create(:development_admin, permission_level: second_division_development, email: second_division_development_email)
  end

  def create_development_admin
    FactoryGirl.create(:development_admin, permission_level: development, email: development_email)
  end


  # INSTANCES

  def developer_name
    "First Developer"
  end

  def developer
    Developer.find_by(company_name: developer_name)
  end

  def developer_email
    "developer@email.com"
  end

  def second_developer_name
    "Second Developer"
  end

  def second_developer
    Developer.find_by(company_name: second_developer_name)
  end

  def second_developer_email
    "seconddeveloper@email.com"
  end

  def division_name
    "First Division"
  end

  def division
    Division.find_by(division_name: division_name)
  end

  def division_email
    "division@email.com"
  end

  def second_division_name
    "Second Division"
  end

  def second_division
    Division.find_by(division_name: second_division_name)
  end

  def second_division_development_name
    "Second Division Development"
  end

  def second_division_development
    Development.find_by(name: second_division_development_name)
  end

  def second_division_development_email
    "divisiondevelopment@email.com"
  end

  def development_name
    "First Development"
  end

  def development
    Development.find_by(name: development_name)
  end

  def development_email
    "development@email.com"
  end
end
