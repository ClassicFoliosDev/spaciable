# frozen_string_literal: true
module CFAdminUserFixture
  module_function

  def create
    FactoryGirl.create(:cf_admin, email: email, password: password)
  end

  def email
    "admin@hoozzi.com"
  end

  def password
    "12345678"
  end
end
