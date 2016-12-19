# frozen_string_literal: true
FactoryGirl.define do
  factory :development do
    name { "#{Faker::Company.name} Development" }
    postal_name { Faker::Address.street_name }
    building_name { Faker::Address.street_name }
    road_name { Faker::Address.street_name }
    city { Faker::Address.city }
    postcode { Faker::Address.postcode }
    email { Faker::Internet.email }
    contact_number { "+44 #{Faker::Number.number(9)}" }
    developer
  end
end
