# frozen_string_literal: true
require "rails_helper"

RSpec.describe Plot do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:development) }
    let(:association_with_parent) { :plots }
  end
end
