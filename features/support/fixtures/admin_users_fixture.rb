# frozen_string_literal: true
module AdminUsersFixture
  module_function

  def create_cf_admin
    create_permission_resources
    FactoryGirl.create(:cf_admin)
  end

  def create_developer_admin
    create_permission_resources
    FactoryGirl.create(:developer_admin, permission_level: developer)
  end

  def create_division_admin
    create_permission_resources
    FactoryGirl.create(:division_admin, permission_level: division)
  end

  def create_development_admin
    create_permission_resources
    FactoryGirl.create(:development_admin, permission_level: development)
  end

  def create_division_development_admin
    create_permission_resources
    FactoryGirl.create(:development_admin, permission_level: division_development)
  end

  def create_permission_resources
    create_developer
    create_division
    create_development
    create_division_development
  end

  def second_cf_admin_attrs
    { email_address: "second@cf.com", role: "CF Admin" }
  end

  def second_cf_admin_update_attrs
    { email_address: "second.admin@cf.co.uk", role: "CF Admin" }
  end

  def second_cf_admin_id
    (User.find_by(email: second_cf_admin_attrs[:email_address]) ||
      User.find_by(email: second_cf_admin_update_attrs[:email_address])).id
  end

  def create_developer
    FactoryGirl.create(:developer, company_name: developer_name)
  end

  def create_division
    FactoryGirl.create(:division, division_name: division_name, developer: developer)
  end

  def create_development
    FactoryGirl.create(:development, name: development_name, developer: developer)
  end

  def create_division_development
    FactoryGirl.create(:division_development, name: division_development_name, division: division)
  end

  def developer_name
    "Hamble View"
  end

  def division_name
    "Hamble Riverside"
  end

  def development_name
    "Hamble Riverside Apartments"
  end

  def division_development_name
    "Hamble East Riverside Housing"
  end

  def developer
    Developer.find_by(company_name: developer_name)
  end

  def division
    Division.find_by(division_name: division_name)
  end

  def development
    Development.find_by(name: development_name)
  end

  def division_development
    Development.find_by(name: division_development_name)
  end

  def developer_admin_attrs
    { email_address: "developer@cf.com", role: "Developer Admin", developer: developer_name }
  end

  def division_admin_attrs
    {
      email_address: "division@cf.com",
      role: "Division Admin", division: division_name,
      developer: developer
    }
  end

  def development_admin_attrs
    {
      email_address: "development@cf.com",
      role: "Development Admin",
      developer: developer,
      development: development_name
    }
  end

  def division_development_admin_attrs
    {
      email_address: "division.development@cf.com",
      role: "Development Admin",
      developer: developer,
      division: division,
      development: division_development_name
    }
  end
end
