# frozen_string_literal: true
require "rails_helper"

RSpec.describe UnitType do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:development) }
    let(:association_with_parent) { :unit_types }
  end

  describe "#name=" do
    context "under the same development" do
      it "should not allow duplicate unit_type names" do
        name = "Only unit_type named this"
        development = create(:development)
        create(:unit_type, name: name, development: development)
        unit_type = UnitType.new(name: name, development: development)

        unit_type.validate
        name_errors = unit_type.errors.details[:name]

        expect(name_errors).to include(error: :taken, value: name)
      end
    end

    context "under different developments" do
      it "should allow duplicate unit_type names" do
        name = "Only unit_type named this"
        create(:unit_type, name: name)
        unit_type = UnitType.new(name: name)

        unit_type.validate
        name_errors = unit_type.errors.details[:name]

        expect(name_errors).not_to include(error: :taken, value: name)
      end
    end
  end

  describe "#destroy" do
    subject { FactoryGirl.create(:unit_type) }

    include_examples "archive when destroyed"
    it_behaves_like "archiving is dependent on parent association", :developer
    it_behaves_like "archiving is dependent on parent association", :division do
      subject { FactoryGirl.create(:unit_type, development: create(:division_development)) }
    end
    it_behaves_like "archiving is dependent on parent association", :development
  end
end
