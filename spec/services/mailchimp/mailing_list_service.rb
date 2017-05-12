# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mailchimp::MailingListService do
  let(:developer) { create(:developer) }
  let(:division) { create(:division, developer: developer) }

  context "creating a division" do
    it "builds the mailing list parameters" do
      segment_params = described_class.build_list_params(division)

      expect(segment_params).to include(
        name: division.division_name,
        contact: {
          company: I18n.t("mailchimp.company"),
          address1: I18n.t("mailchimp.address1"),
          address2: I18n.t("mailchimp.address2"),
          city: I18n.t("mailchimp.city"),
          state: I18n.t("mailchimp.state"),
          zip: I18n.t("mailchimp.zip"),
          country: I18n.t("mailchimp.country")
        },
        permission_reminder: I18n.t("mailchimp.reminder"),
        campaign_defaults: {
          from_name: I18n.t("mailchimp.from_name"),
          from_email: I18n.t("mailchimp.from_email"),
          subject: "",
          language: I18n.t("mailchimp.language")
        },
        email_type_option: true
      )
    end
  end
end
