# frozen_string_literal: true
FactoryGirl.define do
  factory :address do
    postal_name { Faker::Address.street_name }
    building_name { Faker::Address.street_name }
    road_name { Faker::Address.street_name }
    city { Faker::Address.city }
    postcode { Faker::Address.postcode }
  end
end
