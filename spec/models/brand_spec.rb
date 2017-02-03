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
end
