# frozen_string_literal: true
require "rails_helper"

RSpec.describe Division do
  describe "#destroy" do
    subject { FactoryGirl.create(:division) }

    include_examples "archive when destroyed"
    it_behaves_like "archiving is dependent on parent association", :developer
  end
end
