# frozen_string_literal: true

require_relative "create_fixture"

module AdminUsersFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def create_permission_resources(cas: false)
    create_developer(cas: cas)
    create_division
    create_development(cas: cas)
    create_division_development(cas: cas)
  end

  def create_spanish_permission_resources
    create_spanish_developer
    create_spanish_division
    create_spanish_development
    create_spanish_division_development
  end

  def new_password
    "barFoo21"
  end

  def additional_developer_name
    "Peter Piper"
  end

  def additional_division_name
    "Redhat"
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

  def additional_CF_admin_attrs
    { role: "CF Admin" }
  end

  def developer_admin_attrs
    { email_address: "developer@cf.com",
      role: "Developer Admin",
      developer: developer_name,
    }
  end

  def additional_developer_admin_attrs
    { role: "Developer Admin",
      developer: additional_developer_name
    }
  end

  def division_admin_attrs
    {
      email_address: "division@cf.com",
      role: "Division Admin", division: division_name,
      developer: developer
    }
  end

  def additional_division_admin_attrs
    {
      role: "Division Admin", division: additional_division_name,
      developer: additional_developer_name
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
