# frozen_string_literal: true
require "rails_helper"

RSpec.describe Development do
  describe "#parent" do
    it "must have a developer_id or division_id" do
      development = described_class.new(developer_id: nil, division_id: nil)

      development.validate

      error = I18n.t("activerecord.errors.messages.missing_permissable_id")
      expect(development.errors[:base]).to include(error)
    end

    context "when it belongs to a division" do
      it "should be the division" do
        division = create(:division)
        development = described_class.new(division: division)

        expect(development.parent).to eq(division)
      end
    end

    context "when it belongs to a developer" do
      it "should be the developer" do
        developer = create(:developer)
        development = described_class.new(developer: developer)

        expect(development.parent).to eq(developer)
      end
    end
  end

  describe "#destroy" do
    it "should be archived" do
      development = create(:development)

      development.destroy!

      expect(described_class.all).not_to include(development)
      expect(described_class.with_deleted).to include(development)
    end

    it "should be archived when the parent developer is destroyed" do
      development = create(:development)

      development.developer.destroy!

      expect(described_class.all).not_to include(development)
      expect(described_class.with_deleted).to include(development)
    end
    it "should be archived when the parent division is destroyed" do
      development = create(:division_development)

      development.division.destroy!

      expect(described_class.all).not_to include(development)
      expect(described_class.with_deleted).to include(development)
    end
  end
end
