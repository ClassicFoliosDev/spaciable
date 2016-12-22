# frozen_string_literal: true
require "rails_helper"

RSpec.describe Finish do
  include_examples "it inherits permissable ids from the parent" do
    let(:parent) { create(:room) }
    let(:association_with_parent) { :finishes }
  end
end
