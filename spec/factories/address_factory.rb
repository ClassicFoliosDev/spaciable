# frozen_string_literal: true

FactoryGirl.define do
  factory :address do
    postal_number { Faker::Address.street_name }
    building_name { Faker::Address.street_name }
    road_name { Faker::Address.street_name }
    locality { Faker::Address.city_prefix }
    city { Faker::Address.city }
    postcode { Faker::Address.postcode }
  end
end
