# frozen_string_literal: true
require "rails_helper"

RSpec.describe Room do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:unit_type) }
    let(:association_with_parent) { :rooms }
  end
end
