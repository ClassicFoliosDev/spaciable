# frozen_string_literal: true
require "rails_helper"

RSpec.describe UnitType do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:development) }
    let(:association_with_parent) { :unit_types }
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
