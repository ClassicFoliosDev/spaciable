# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Admin Dashboard" do
  subject { get admin_dashboard_path }

  it "should not allow homeowners to acces the admin area" do
    login_as create(:resident)

    expect(subject).to redirect_to(homeowner_dashboard_path)
  end
end
