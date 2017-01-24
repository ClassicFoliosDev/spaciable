# frozen_string_literal: true
require "rails_helper"
require "cancan/matchers"

RSpec.describe "Notification Abiltities" do
  subject { Ability.new(current_user) }

  context "as a Developer Admin" do
    let(:current_user) { create(:developer_admin) }

    it "can manage notifications under the users developer" do
      developer = current_user.permission_level
      notification = Notification.new(send_to: developer)

      expect(subject).to be_able_to(:read, notification)
    end

    it "cannot manage notifications under others developers" do
      developer = create(:developer)
      notification = Notification.new(send_to: developer)

      expect(subject).not_to be_able_to(:manage, notification)
    end
  end
end
