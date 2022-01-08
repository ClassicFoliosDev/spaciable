# frozen_string_literal: true

require "rails_helper"

RSpec.describe Finish do
  let(:finish_category) { create(:finish_category, name: "Test category") }
  let(:finish_type) { create(:finish_type, name: "Test type",
                             finish_categories: [finish_category]) }
  let(:finish_manufacturer) { create(:finish_manufacturer, name: "Test man",
                              finish_types: [finish_type]) }
  RequestStore.store[:current_user] = User.new(first_name: "Test", email: "test@test.com")

  describe "#name=" do
    it "should not allow duplicate name/cat/type combos" do
      name = "Only finish named this"
      create(:finish, name: name,
              finish_type: finish_type,
              finish_category: finish_category,
              finish_manufacturer: finish_manufacturer)
      finish = Finish.new(name: name,
                          finish_type: finish_type,
                          finish_category: finish_category,
                          finish_manufacturer: finish_manufacturer)



      finish.validate
      expect(finish.errors.details[:finish][0][:error]).to eq(I18n.t("finishes.duplicate.message"))
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
