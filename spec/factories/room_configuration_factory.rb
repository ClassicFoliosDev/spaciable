# frozen_string_literal: true

FactoryGirl.define do
  factory :room_configuration do
    name { "#{Faker::Name}" }
    choice_configuration
  end
end
