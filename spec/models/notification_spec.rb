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

  describe "send_to" do
    describe "must be equal or below the senders role permissions" do
      context "as a development_admin" do
        it "should be valid if send_to is a development" do
          development = create(:development)
          development_admin = create(:development_admin, permission_level: development)
          notification = build(:notification, sender: development_admin, send_to: development)

          notification.validate

          expect(notification).to be_valid
        end

        it "should be valid if send_to is a phase" do
          development = create(:development)
          phase = create(:phase, development: development)
          development_admin = create(:development_admin, permission_level: development)
          notification = build(:notification, sender: development_admin, send_to: phase)

          notification.validate

          expect(notification).to be_valid
          expect(notification.send_to).to eq(phase)
        end

        context "when send_to is a developer" do
          it "should return a development_id blank error" do
            selection_error = I18n.t("activerecord.errors.messages.select")
            developer = create(:developer)
            development = create(:development, developer: developer)
            current_user = create(:development_admin, permission_level: development)
            notification = build(:notification, sender: current_user, send_to: developer)

            notification.validate

            expect(notification.errors[:development_id]).to include(selection_error)
          end
        end

        context "when send_to is a division" do
          it "should return a development_id blank error" do
            selection_error = I18n.t("activerecord.errors.messages.select")
            division = create(:division)
            development = create(:division_development, division: division)
            current_user = create(:development_admin, permission_level: development)
            notification = build(:notification, sender: current_user, send_to: division)

            notification.validate

            expect(notification.errors[:development_id]).to include(selection_error)
          end
        end
      end

      context "as a division_admin" do
        it "should be valid if send_to is a division" do
          division = create(:division)
          division_admin = create(:division_admin, permission_level: division)
          notification = build(:notification, sender: division_admin, send_to: division)

          notification.validate

          expect(notification).to be_valid
          expect(notification.send_to).to eq(division)
        end

        it "should be valid if send_to is a division development" do
          division = create(:division)
          development = create(:division_development, division: division)
          division_admin = create(:division_admin, permission_level: division)
          notification = build(:notification, sender: division_admin, send_to: development)

          notification.validate

          expect(notification).to be_valid
          expect(notification.send_to).to eq(development)
        end

        it "should be valid if send_to is a division development phase" do
          division = create(:division)
          division_development = create(:division_development, division: division)
          phase = create(:phase, development: division_development)
          division_admin = create(:division_admin, permission_level: division)
          notification = build(:notification, sender: division_admin, send_to: phase)

          notification.validate

          expect(notification).to be_valid
          expect(notification.send_to).to eq(phase)
        end

        context "when send_to is a developer" do
          it "should return a division_id blank error" do
            selection_error = I18n.t("activerecord.errors.messages.select")
            developer = create(:developer)
            division = create(:division, developer: developer)
            current_user = create(:division_admin, permission_level: division)
            notification = build(:notification, sender: current_user, send_to: developer)

            notification.validate

            expect(notification.errors[:division_id]).to include(selection_error)
          end
        end
      end

      context "as a developer_admin" do
        it "should be valid if send_to is a developer" do
          developer = create(:developer)
          developer_admin = create(:developer_admin, permission_level: developer)
          notification = build(:notification, sender: developer_admin, send_to: developer)

          notification.validate

          expect(notification).to be_valid
          expect(notification.send_to).to eq(developer)
        end

        it "should be valid if send_to is a division" do
          developer = create(:developer)
          division = create(:division, developer: developer)

          developer_admin = create(:developer_admin, permission_level: developer)
          notification = build(:notification, sender: developer_admin, send_to: division)

          notification.validate

          expect(notification).to be_valid
          expect(notification.send_to).to eq(division)
        end

        it "should be valid if send_to is a development" do
          developer = create(:developer)
          development = create(:development, developer: developer)

          developer_admin = create(:developer_admin, permission_level: developer)
          notification = build(:notification, sender: developer_admin, send_to: development)

          notification.validate

          expect(notification).to be_valid
        end

        it "should be valid if send_to is a phase" do
          developer = create(:developer)
          development = create(:development, developer: developer)
          phase = create(:phase, development: development)

          developer_admin = create(:developer_admin, permission_level: developer)
          notification = build(:notification, sender: developer_admin, send_to: phase)

          notification.validate

          expect(notification).to be_valid
          expect(notification.send_to).to eq(phase)
        end

        context "when send_to is blank" do
          it "should return a developer_id blank error" do
            selection_error = I18n.t("activerecord.errors.messages.select")
            developer = create(:developer)
            current_user = create(:developer_admin, permission_level: developer)
            notification = build(:notification, sender: current_user, send_to: nil)

            notification.validate
            expect(notification.errors[:developer_id]).to include(selection_error)
          end
        end
      end
    end
  end
end
