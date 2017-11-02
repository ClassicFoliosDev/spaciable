# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Redirect" do
  subject { get developers_path }

  it "should not allow homeowners to acces the admin area" do
    login_as create(:resident, :with_residency)

    expect(subject).to redirect_to(homeowner_dashboard_path)
  end
end
