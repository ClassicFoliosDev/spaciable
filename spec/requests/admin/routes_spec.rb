# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Routes" do
  it "should allow new admin users to accept the invitation" do
    url = "/admin/invitation/accept?invitation_token=abc123"

    expect(get(url)).to redirect_to("http://www.example.com/admin/sign_in")
  end
end
