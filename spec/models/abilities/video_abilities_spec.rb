# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Video Abilities" do
  subject { Ability.new(current_user) }

  describe "videos" do
    context "As a developer admin" do
      specify "can manage videos for developments under the developer" do
        developer = create(:developer)
        development = create(:development, developer: developer)
        video = build(:video, videoable: development)

        developer_admin = create(:developer_admin, permission_level: developer)
        ability = Ability.new(developer_admin)

        expect(ability).to be_able_to(:manage, video)
      end

      specify "cannot manage vidoes for developments under another developer" do
        developer = create(:developer)
        other_development = create(:development)
        video = build(:video, videoable: other_development)

        developer_admin = create(:developer_admin, permission_level: developer)
        ability = Ability.new(developer_admin)

        expect(ability).not_to be_able_to(:manage, video)
      end
    end

    context "As a division admin" do
      specify "can manage videos for developments under the division" do
        developer = create(:developer)
        division = create(:division, developer: developer)
        development = create(:development, division: division)
        video = build(:video, videoable: development)

        division_admin = create(:division_admin, permission_level: division)
        ability = Ability.new(division_admin)

        expect(ability).to be_able_to(:manage, video)
      end

      specify "cannot manage vidoes for developments under the parent developer" do
        developer = create(:developer)
        division = create(:division, developer: developer)
        other_development = create(:development, developer: developer)
        video = build(:video, videoable: other_development)

        division_admin = create(:division_admin, permission_level: division)
        ability = Ability.new(division_admin)

        expect(ability).not_to be_able_to(:manage, video)
      end
    end

    context "As a development admin" do
      specify "can manage videos for my development" do
        developer = create(:developer)
        development = create(:development, developer: developer)
        video = build(:video, videoable: development)

        development_admin = create(:development_admin, permission_level: development)
        ability = Ability.new(development_admin)

        expect(ability).to be_able_to(:manage, video)
      end

      specify "cannot manage vidoes for other developments" do
        developer = create(:developer)
        development = create(:development, developer: developer)
        other_development = create(:development, developer: developer)
        video = build(:video, videoable: other_development)

        development_admin = create(:development_admin, permission_level: development)
        ability = Ability.new(development_admin)

        expect(ability).not_to be_able_to(:manage, video)
      end
    end
  end
end
