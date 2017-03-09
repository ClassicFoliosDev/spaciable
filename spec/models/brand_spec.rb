# frozen_string_literal: true
require "rails_helper"

RSpec.describe Brand do
  describe "validate hex colors" do
    it "must have valid hex colours" do
      brand = described_class.new(bg_color: nil,
                                  text_color: "33ff55",
                                  content_bg_color: "#77EE33",
                                  content_text_color: "FFF",
                                  button_color: "#000")
      brand.validate

      expect(brand.errors).to be_empty
    end

    it "fails with invalid hex colours" do
      test_values = ["foo", "22443", "557766;", "#31311"]
      error = I18n.t("activerecord.errors.messages.not_valid_hex")

      test_values.each do |value|
        brand = described_class.new(bg_color: value)
        brand.validate
        expect(brand.errors[:bg_color]).to include(error)
      end
    end
  end

  describe "#branded_text_color" do
    it "should use the text color on the brand" do
      white = "#FFFFFF"
      brand = create(:brand, text_color: white)

      expect(brand.branded_text_color).to eq(white)
    end

    context "brand is blank but parent brand is not" do
      it "should use the text_color from the parent brand" do
        white = "#FFFFFF"
        development = create(:development)
        phase = create(:phase, development: development)

        brand = create(:brand, text_color: nil, brandable: phase)
        parent_brand = create(:brand, text_color: white, brandable: development)

        expect(brand.branded_text_color).to eq(parent_brand.branded_text_color)
      end
    end

    context "brand is blank but parent parent brand is not" do
      it "should use the text_color from the parent brand" do
        white = "#FFFFFF"
        developer = create(:developer)
        development = create(:development, developer: developer)
        phase = create(:phase, development: development)

        brand = create(:brand, text_color: nil, brandable: phase)
        create(:brand, text_color: nil, brandable: development)
        parent_parent_brand = create(:brand, text_color: white, brandable: developer)

        expect(brand.branded_text_color).to eq(parent_parent_brand.branded_text_color)
      end
    end

    context "brand and all parent brands are blank" do
      it "should return the default brand color" do
        developer = create(:developer)
        development = create(:development, developer: developer)
        phase = create(:phase, development: development)

        brand = create(:brand, text_color: nil, brandable: phase)
        create(:brand, text_color: nil, brandable: development)
        create(:brand, text_color: nil, brandable: developer)

        expect(brand.branded_text_color).to eq(nil)
      end
    end

    context "brand does not exist for division" do
      it "should return the developer brand color" do
        white = "#FFFFFF"
        developer = create(:developer)
        division = create(:division, developer: developer)
        development = create(:development, division: division)

        parent_parent_brand = create(:brand, text_color: white, brandable: developer)
        brand = create(:brand, text_color: nil, brandable: development)

        expect(brand.branded_text_color).to eq(parent_parent_brand.branded_text_color)
      end
    end
  end
end
