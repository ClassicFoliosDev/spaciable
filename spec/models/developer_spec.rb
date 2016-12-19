# frozen_string_literal: true
RSpec.describe Developer do
  describe "#destroy" do
    it "should be archived" do
      developer = create(:developer)

      developer.destroy!

      expect(described_class.all).not_to include(developer)
      expect(described_class.with_deleted).to include(developer)
    end
  end
end
