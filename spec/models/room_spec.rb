# frozen_string_literal: true

require "rails_helper"

RSpec.describe Room do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:unit_type) }
    let(:association_with_parent) { :rooms }
  end

  describe "#name=" do
    context "under the same unit_type" do
      it "should not allow duplicate room names" do
        name = "Only room named this"
        development = create(:development)
        development_admin = create(:development_admin, permission_level: development)
        unit_type = create(:unit_type)
        create(:room, name: name, unit_type: unit_type, last_updated_by: development_admin.display_name)
        room = Room.new(name: name, unit_type: unit_type, last_updated_by: development_admin.display_name)

        room.validate
        name_errors = room.errors.details[:name]

        expect(name_errors).to include(error: :taken, value: name)
      end
    end

    context "under different unit_types" do
      it "should allow duplicate room names" do
        name = "Only room named this"
        development = create(:development)
        development_admin = create(:development_admin, permission_level: development)
        create(:room, name: name, last_updated_by: development_admin.display_name)
        room = Room.new(name: name)

        room.validate
        name_errors = room.errors.details[:name]

        expect(name_errors).not_to include(error: :taken, value: name)
      end
    end
  end

  describe "#destroy" do
    subject { FactoryGirl.create(:room, last_updated_by: create(:development_admin, permission_level: create(:development)).display_name) }

    include_examples "archive when destroyed"
    it_behaves_like "archiving is dependent on parent association", :developer
    it_behaves_like "archiving is dependent on parent association", :division do
      let(:unit_type) { create(:unit_type, development: create(:division_development)) }
      subject { FactoryGirl.create(:room, unit_type: unit_type, last_updated_by: create(:development_admin, permission_level: create(:development)).display_name) }
    end
    it_behaves_like "archiving is dependent on parent association", :development
    it_behaves_like "archiving is dependent on parent association", :unit_type
  end
end
