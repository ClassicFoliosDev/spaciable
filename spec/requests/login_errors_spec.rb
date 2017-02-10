# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Login Errors" do
  it "renders the create form with the user layout on error" do
    get "/homeowners/sign_in", params: { email: "not an email" }

    expect(response).to render_template("sessions/new")
  end
end
