# frozen_string_literal: true
require "rails_helper"
require "cancan/matchers"

RSpec.describe "FAQ Abilities" do
  subject { Ability.new(current_user) }

  it_behaves_like "it has cascading polymorphic abilities", Faq
end
