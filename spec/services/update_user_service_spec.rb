# frozen_string_literal: true
require "rails_helper"

RSpec.describe UpdateUserService do
  context "user params include valid new password" do
    it "successfully updates the password" do
      user = create(:cf_admin, email: "email@foo.com", password: "12345678")
      user_params = {}
      user_params[:password] = "f00bar12"
      user_params[:password_confirmation] = "f00bar12"
      user_params[:current_password] = "12345678"

      result = described_class.call(user, user_params)

      expect(result).to eq(true)
    end
  end

  context "user params include non-matching password" do
    it "fails to update the password" do
      user = create(:cf_admin, email: "email@foo.com", password: "12345678")
      user_params = {}
      user_params[:password] = "f00bar12"
      user_params[:password_confirmation] = "wrong"
      user_params[:current_password] = "12345678"

      result = described_class.call(user, user_params)

      expect(result).to eq(false)
    end
  end

  context "user params do not include password" do
    it "updates the params" do
      user = create(:cf_admin, email: "email@foo.com", password: "12345678")
      user_params = {}
      user_params[:first_name] = "Jane"
      user_params[:last_name] = "Doe"

      result = described_class.call(user, user_params)

      expect(result).to eq(true)
      expect(user.first_name).to eq("Jane")
      expect(user.last_name).to eq("Doe")
    end
  end

  context "user params include unnecessary current password" do
    it "ignores the password" do
      user = create(:cf_admin, email: "email@foo.com", password: "12345678")
      user_params = {}
      user_params[:first_name] = "Jane"
      user_params[:last_name] = "Doe"
      user_params[:current_password] = "12345678"

      result = described_class.call(user, user_params)

      expect(result).to eq(true)
      expect(user.first_name).to eq("Jane")
      expect(user.last_name).to eq("Doe")
    end
  end
end
