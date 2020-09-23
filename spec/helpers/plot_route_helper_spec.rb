# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlotRouteHelper do
  context "given a developer development" do
    it "should build the developer development route" do
      developer = create(:developer, company_name: "Developer name")
      development = create(:development, developer: developer, name: "Development name")
      plot = create(:plot, development: development)

      result = resident_sign_in_route(plot)
      expect(result).to eq("http://test.host/#{development.id}/sign_in")
    end
  end

  context "given a division development" do
    it "should build the division development route" do
      developer = create(:developer, company_name: "Developer name")
      division = create(:division, developer: developer, division_name: "Division name")
      development = create(:development, division: division, developer: developer, name: "Development name")
      plot = create(:plot, development: development)

      result = resident_sign_in_route(plot)
      expect(result).to eq("http://test.host/#{development.id}/sign_in")
    end
  end
end
