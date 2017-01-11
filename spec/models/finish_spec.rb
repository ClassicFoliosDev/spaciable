# frozen_string_literal: true
require "rails_helper"

RSpec.describe Finish do
  describe "#destroy" do
    context "when room is destroyed" do
      it "should destroy the finish" do
        finish = create(:finish)

        expect { finish.room.destroy! }.to change(Finish, :count).by(-1)
      end
    end
  end
end
