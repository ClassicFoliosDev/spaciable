# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminNavigationHelper do
  context "given a developer" do
    it "should return the developers url" do
      developer = create(:developer)

      url = my_admin_area_url(User.new(role: :developer_admin, permission_level_type: "Developer", permission_level_id: developer.id))

      expect(url).to eq(developer_path(developer))
    end
  end

  context "given a division" do
    it "should return the divisions url" do
      developer = create(:developer)
      division = create(:division, developer: developer)

      url = my_admin_area_url(User.new(role: :division_admin, permission_level_type: "Division", permission_level_id: division.id))

      expect(url).to eq(developer_division_path(developer, division))
    end
  end

  context "given a development" do
    it "should return the development url" do
      developer = create(:developer)
      development = create(:development, developer: developer)

      url = my_admin_area_url(User.new(role: :development_admin, permission_level_type: "Development", permission_level_id: development.id))

      expect(url).to eq(developer_development_path(developer, development))
    end
  end

  context "given a division development" do
    it "should return the divisions url" do
      developer = create(:developer)
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)

      url = my_admin_area_url(User.new(role: :development_admin, permission_level_type: "Development", permission_level_id: division_development.id))

      expect(url).to eq(division_development_path(division, division_development))
    end
  end
end
