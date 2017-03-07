# frozen_string_literal: true
require "rails_helper"

RSpec.describe Finish do
  describe "#name=" do
    it "should not allow duplicate company names" do
      name = "Only finish named this"
      create(:finish, name: name)
      finish = Finish.new(name: name)

      finish.validate
      name_errors = finish.errors.details[:name]

      expect(name_errors).to include(error: :taken, value: name)
    end
  end

  describe "#destroy" do
    it "should be archived" do
      finish = create(:finish)

      finish.destroy!

      expect(described_class.all).not_to include(finish)
      expect(described_class.with_deleted).to include(finish)
    end
  end
end
