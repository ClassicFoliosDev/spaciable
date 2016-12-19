# frozen_string_literal: true
require "rails_helper"

RSpec.describe Development do
  describe "#destroy" do
    it "should be archived" do
      development = create(:development)

      development.destroy!

      expect(described_class.all).not_to include(development)
      expect(described_class.with_deleted).to include(development)
    end

    it "should be archived when the developer is destroyed" do
      development = create(:development)

      development.developer.destroy!

      expect(described_class.all).not_to include(development)
      expect(described_class.with_deleted).to include(development)
    end
  end
end
