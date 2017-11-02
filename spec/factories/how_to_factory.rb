# frozen_string_literal: true

FactoryGirl.define do
  factory :how_to do
    title { Faker::Lorem.sentence }
    summary { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(3) }
    category { 0 }
  end
end
