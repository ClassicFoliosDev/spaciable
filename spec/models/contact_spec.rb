# frozen_string_literal: true
require "rails_helper"

RSpec.describe Contact do
  describe "#contactable" do
    it "must have an email or a phone number" do
      contact = described_class.new(email: nil, phone: nil)

      contact.validate

      error = I18n.t("activerecord.errors.models.contact.attributes.base.email_or_phone_required")
      expect(contact.errors[:base]).to include(error)
    end
  end

  describe "#identifiable" do
    it "must have an name or an organisation" do
      contact = described_class.new(first_name: nil, last_name: nil, organisation: nil)
      error = I18n.t("activerecord.errors.models.contact.attributes.base.name_or_organisation_required")

      contact.validate

      expect(contact.errors[:base]).to include(error)
    end
  end
end
