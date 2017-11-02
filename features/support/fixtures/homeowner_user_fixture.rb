# frozen_string_literal: true

module HomeownerUserFixture
  module_function

  def create
    FactoryGirl.create(
      :resident,
      :with_residency,
      email: email,
      password: password,
      first_name: first_name
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
