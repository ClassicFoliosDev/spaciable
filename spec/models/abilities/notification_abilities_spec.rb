# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Notification Abiltities" do
  subject { Ability.new(current_user) }

  it_behaves_like "it has cascading polymorphic abilities", Notification do
    let(:unsafe_actions) { %i[create send] }
    let(:safe_actions) { [:read] }
    let(:belongs_to_association) { :send_to }
  end

  context "as a CF Admin" do
    let(:current_user) { create(:cf_admin) }

    it "can send a notification to all" do
      notification = Notification.new(send_to_all: true)

      expect(subject).to be_able_to(:send, notification)
    end
  end

  context "as a Developer Admin" do
    let(:current_user) { create(:developer_admin) }

    it "cannot send a notification to all" do
      developer = current_user.permission_level
      notification = Notification.new(send_to_all: true, send_to: developer)

      expect(subject).not_to be_able_to(:send, notification)
      expect(subject).not_to be_able_to(:create, notification)
      expect(subject).not_to be_able_to(:read, notification)

      expect(subject).not_to be_able_to(:send_to_all, Notification)
    end
  end

  context "as a Division Admin" do
    let(:current_user) { create(:division_admin) }

    it "cannot send a notification to all" do
      division = current_user.permission_level
      notification = Notification.new(send_to_all: true, send_to: division)

      expect(subject).not_to be_able_to(:send, notification)
      expect(subject).not_to be_able_to(:create, notification)
      expect(subject).not_to be_able_to(:read, notification)

      expect(subject).not_to be_able_to(:send_to_all, Notification)
    end
  end

  context "as a Development Admin" do
    let(:current_user) { create(:development_admin) }

    it "cannot send a notification to all" do
      development = current_user.permission_level
      notification = Notification.new(send_to_all: true, send_to: development)

      expect(subject).not_to be_able_to(:send, notification)
      expect(subject).not_to be_able_to(:create, notification)
      expect(subject).not_to be_able_to(:read, notification)

      expect(subject).not_to be_able_to(:send_to_all, Notification)
    end
  end
end
