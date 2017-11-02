# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login Errors" do
  it "renders the create form with the admin layout on error" do
    get "/admin", params: { email: "not an email" }

    expect(response).to render_template("devise/sessions/new")
  end
end
