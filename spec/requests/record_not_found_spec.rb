# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Record Not Found" do
  it "should redirect to the root url" do
    login_as create(:cf_admin)
    get developer_path("imaginary id")

    expect(response.redirect_url).to eq(root_url)
  end
end
