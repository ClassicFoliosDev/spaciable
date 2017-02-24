# frozen_string_literal: true
require "rails_helper"

RSpec.describe Notification do
  describe "#sent_to" do
    context "when there is no plots specified" do
      it "should return the send_to string representation" do
        developer = create(:developer)
        notification = build(:notification, send_to: developer)

        expect(notification.sent_to).to eq(developer.to_s)
      end
    end
    context "when a single plot is specified" do
      it "should return the send_to value and the plot number" do
        plot = create(:plot)
        developer = plot.developer
        notification = create(:notification, send_to: developer, plot_numbers: [plot.number])

        expect(notification.sent_to).to eq("#{developer} (Plot #{plot.number})")
      end
    end

    context "when a list of plots are speficied" do
      it "should return the send_tot value and the plot numbers" do
        numbers = [3, 5, 7, 8, 9, 10]
        developer = create(:developer)
        notification = create(:notification, send_to: developer, plot_numbers: numbers)

        expect(notification.sent_to).to eq("#{developer} (Plots #{numbers.to_sentence})")
      end
    end
  end

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

  describe "send_to_all?" do
    context "as a CF Admin" do
      context "with send_to_all set to true" do
        it "should be true" do
          cf_admin = create(:cf_admin)
          notification = build(:notification, sender: cf_admin, send_to: nil)

          expect(notification.send_to_all?).to eq(false)

          notification.send_to_all = true
          expect(notification.send_to_all?).to eq(true)
        end
      end
    end

    context "as a Developer Admin" do
      context "with send_to_all set to true" do
        it "should be false" do
          developer_admin = create(:developer_admin)
          notification = build(:notification, sender: developer_admin, send_to: nil)

          expect(notification.send_to_all?).to eq(false)
          notification.send_to_all = true
          expect(notification.send_to_all?).to eq(false)
        end
      end
    end

    context "as a Division Admin" do
      context "with send_to_all set to true" do
        it "should be false" do
          division_admin = create(:division_admin)
          notification = build(:notification, sender: division_admin, send_to: nil)

          expect(notification.send_to_all?).to eq(false)
          notification.send_to_all = true
          expect(notification.send_to_all?).to eq(false)
        end
      end
    end

    context "as a Development Admin" do
      context "with send_to_all set to true" do
        it "should be false" do
          development_admin = create(:development_admin)
          notification = build(:notification, sender: development_admin, send_to: nil)

          expect(notification.send_to_all?).to eq(false)
          notification.send_to_all = true
          expect(notification.send_to_all?).to eq(false)
        end
      end
    end
  end

  describe "send_to" do
    describe "must be equal or below the senders role permissions" do
      context "as a cf_admin" do
        it "should not be valid if send_to is present and sent_to_all is true" do
          cf_admin = create(:cf_admin)
          notification = build(:notification, sender: cf_admin, send_to_all: true)

          notification.validate

          expect(notification.errors[:send_to_all]).not_to be_empty
        end

        it "should not be valid if send_to is blank and sent_to_all is false" do
          cf_admin = create(:cf_admin)
          notification = build(:notification, sender: cf_admin, send_to: nil, send_to_all: false)

          notification.validate

          expect(notification.errors[:send_to]).not_to be_empty
        end

        it "should be valid if send_to is blank but sent_to_all is true" do
          cf_admin = create(:cf_admin)
          notification = build(:notification, sender: cf_admin, send_to: nil, send_to_all: true)

          notification.validate

          expect(notification).to be_valid
        end

        it "should be valid if send_to is a division" do
          cf_admin = create(:cf_admin)
          division = create(:division)
          notification = build(:notification, sender: cf_admin, send_to: division)

          notification.validate

          expect(notification).to be_valid
        end

        it "should be valid if send_to is a development" do
          cf_admin = create(:cf_admin)
          development = create(:development)
          notification = build(:notification, sender: cf_admin, send_to: development)

          notification.validate

          expect(notification).to be_valid
        end

        it "should be valid if send_to is a phase" do
          cf_admin = create(:cf_admin)
          phase = create(:phase)
          notification = build(:notification, sender: cf_admin, send_to: phase)

          notification.validate

          expect(notification).to be_valid
        end
      end

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
