# frozen_string_literal: true

require "rails_helper"

RSpec.describe Developer do
  describe "#company_name=" do
    it "should not allow duplicate company names" do
      company_name = "Only company named this"
      create(:developer, company_name: company_name)
      developer = Developer.new(company_name: company_name)

      developer.validate
      name_errors = developer.errors.details[:company_name]

      expect(name_errors).to include(error: :taken, value: company_name)
    end
  end

  describe "#destroy" do
    it "should be archived" do
      developer = create(:developer)

      developer.destroy!

      expect(described_class.all).not_to include(developer)
      expect(described_class.with_deleted).to include(developer)
    end
  end
end
