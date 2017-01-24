# frozen_string_literal: true
require "rails_helper"

RSpec.describe Notification do
  describe "#with_sender" do
    it "should set the sender" do
      user = create(:developer_admin)
      notification = build(:notification, sender: nil)

      notification.with_sender(user)
      notification.validate

      expect(notification.errors[:sender]).to be_empty
      expect(notification.sender).to eq(user)
    end
  end
end
