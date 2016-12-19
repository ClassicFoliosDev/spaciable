# frozen_string_literal: true
module HomeownerUserFixture
  module_function

  def create
    FactoryGirl.create(
      :homeowner,
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
end
