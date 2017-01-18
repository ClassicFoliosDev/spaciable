# frozen_string_literal: true
require "rails_helper"

RSpec.describe Finish do
  describe "#destroy" do
    context "when room is destroyed" do
      it "should destroy the finish" do
        testfinish = create(:finish)

        testfinish.room.destroy
        expect(Finish.where(id: testfinish.id).count).to eq(0)
      end
    end
  end
end
