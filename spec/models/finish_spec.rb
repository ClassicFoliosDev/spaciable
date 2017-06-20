# frozen_string_literal: true
require "rails_helper"

RSpec.describe Finish do
  let(:finish_category) { create(:finish_category, name: "Test category") }
  let(:finish_type) { create(:finish_type, name: "Test type", finish_category_id: finish_category.id) }

  describe "#name=" do
    it "should not allow duplicate names" do
      name = "Only finish named this"
      create(:finish, name: name, finish_type: finish_type)
      finish = Finish.new(name: name)

      finish.validate
      name_errors = finish.errors.details[:name]

      expect(name_errors).to include(error: :taken, value: name)
    end
  end

  describe "#destroy" do
    it "should be archived" do
      finish = create(:finish, name: "Test finish", finish_type: finish_type)

      finish.destroy!

      expect(described_class.all).not_to include(finish)
      expect(described_class.with_deleted).to include(finish)
    end
  end
end
