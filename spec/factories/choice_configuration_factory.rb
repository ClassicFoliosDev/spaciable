# frozen_string_literal: true

FactoryGirl.define do
  factory :choice_configuration do
    name { "#{Faker::Name}" }
    development
  end
end

