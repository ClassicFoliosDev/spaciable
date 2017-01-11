# frozen_string_literal: true
require "rails_helper"

RSpec.describe Room do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:unit_type) }
    let(:association_with_parent) { :rooms }
  end

  describe "#destroy" do
    subject { FactoryGirl.create(:room) }

    include_examples "archive when destroyed"
    it_behaves_like "archiving is dependent on parent association", :developer
    it_behaves_like "archiving is dependent on parent association", :division do
      let(:unit_type) { create(:unit_type, development: create(:division_development)) }
      subject { FactoryGirl.create(:room, unit_type: unit_type) }
    end
    it_behaves_like "archiving is dependent on parent association", :development
    it_behaves_like "archiving is dependent on parent association", :unit_type
  end
end
