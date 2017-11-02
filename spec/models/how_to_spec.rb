# frozen_string_literal: true

require "rails_helper"

RSpec.describe HowTo do
  describe "featured" do
    it "should not allow multiple how tos to share the same featured position" do
      create(:how_to, featured: 1)
      second_how_to = build(:how_to, featured: 1)

      second_how_to.validate

      error = I18n.t("activerecord.errors.messages.taken")
      expect(second_how_to.errors[:featured]).to include(error)
    end

    it "should allow multiple non-featured how tos" do
      create(:how_to, featured: nil)
      second_how_to = build(:how_to, featured: nil)

      second_how_to.validate

      error = I18n.t("activerecord.errors.messages.taken")
      expect(second_how_to.errors[:featured]).not_to include(error)
    end
  end
end
