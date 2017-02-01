# frozen_string_literal: true
require "rails_helper"
require "cancan/matchers"

RSpec.describe "Contact Abilities" do
  subject { Ability.new(current_user) }

  it_behaves_like "it has cascading polymorphic abilities", Contact
end
