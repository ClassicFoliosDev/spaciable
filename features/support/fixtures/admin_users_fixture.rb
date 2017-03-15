# frozen_string_literal: true
require_relative "create_fixture"

module AdminUsersFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def create_permission_resources
    create_developer
    create_division
    create_development
    create_division_development
  end

  def new_password
    "barFoo21"
  end

  def second_cf_admin_attrs
    { email_address: "second@cf.com", role: "CF Admin" }
  end

  def second_cf_admin_update_attrs
    { first_name: "Second", last_name: "Last name", role: "CF Admin" }
  end

  def second_cf_admin_id
    (User.find_by(email: second_cf_admin_attrs[:email_address]) ||
      User.find_by(email: second_cf_admin_update_attrs[:email_address])).id
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
