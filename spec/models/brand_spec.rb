# frozen_string_literal: true
require "rails_helper"

RSpec.describe Brand do
  describe "validate hex colors" do
    it "must have valid hex colours" do
      brand = described_class.new(bg_color: nil,
                                  text_color: "33ff55",
                                  content_bg_color: "#77EE33",
                                  content_text_color: "FFF",
                                  button_color: "#000",
                                  header_color: "890")
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

    context "brand does not have text_color and parent brand has text_color" do
      it "should use the text_color from the parent brand" do
        white = "#FFFFFF"
        development = create(:development)
        phase = create(:phase, development: development)

        brand = create(:brand, text_color: nil, brandable: phase)
        parent_brand = create(:brand, text_color: white, brandable: development)

        expect(brand.branded_text_color).to eq(parent_brand.branded_text_color)
      end
    end

    context "brand does not have text_color and grandparent brand param has text_color" do
      it "should use the text_color from the grandparent brand" do
        white = "#FFFFFF"
        developer = create(:developer)
        development = create(:development, developer: developer)
        phase = create(:phase, development: development)

        brand = create(:brand, text_color: nil, brandable: phase)
        create(:brand, text_color: nil, brandable: development)
        grandparent_brand = create(:brand, text_color: white, brandable: developer)

        expect(brand.branded_text_color).to eq(grandparent_brand.branded_text_color)
      end
    end

    context "brand and all parent brand params do not have text_color" do
      it "should return nil" do
        developer = create(:developer)
        development = create(:development, developer: developer)
        phase = create(:phase, development: development)

        brand = create(:brand, text_color: nil, brandable: phase)
        create(:brand, text_color: nil, brandable: development)
        create(:brand, text_color: nil, brandable: developer)

        expect(brand.branded_text_color).to eq(nil)
      end
    end

    context "brand does not exist for division and grandparent brand param has text_color" do
      it "should return the grandparent brand text_color" do
        white = "#FFFFFF"
        developer = create(:developer)
        division = create(:division, developer: developer)
        development = create(:development, division: division)

        grandparent_brand = create(:brand, text_color: white, brandable: developer)
        brand = create(:brand, text_color: nil, brandable: development)

        expect(brand.branded_text_color).to eq(grandparent_brand.branded_text_color)
      end
    end

    context "both development and division brand have text_color" do
      it "should return the development text_color" do
        white = "#FFFFFF"
        blue = "#0000FF"
        developer = create(:developer)
        division = create(:division, developer: developer)
        development = create(:development, division: division)

        brand = create(:brand, text_color: blue, brandable: development)
        create(:brand, text_color: white, brandable: division)

        expect(brand.branded_text_color).to eq(blue)
      end
    end

    context "both development and developer brand have text_color" do
      it "should return the development text_color" do
        white = "#FFFFFF"
        blue = "#0000FF"
        developer = create(:developer)
        development = create(:development, developer: developer)

        brand = create(:brand, text_color: blue, brandable: development)
        create(:brand, text_color: white, brandable: developer)

        expect(brand.branded_text_color).to eq(blue)
      end
    end

    context "both division and developer brand have text_color, development has brand but no text_color" do
      it "should return the division text_color" do
        white = "#FFFFFF"
        blue = "#0000FF"
        developer = create(:developer)
        division = create(:division, developer: developer)
        development = create(:development, division: division)

        brand = create(:brand, text_color: nil, brandable: development)
        create(:brand, text_color: blue, brandable: division)
        create(:brand, text_color: white, brandable: developer)

        expect(brand.branded_text_color).to eq(blue)
      end
    end
  end
end
