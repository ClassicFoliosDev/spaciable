# frozen_string_literal: true

FactoryGirl.define do
  factory :service do
    name { Faker::Lorem.words(2).join(" ") }
    description { Faker::Lorem.sentence }
  end
end
