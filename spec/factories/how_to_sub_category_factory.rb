# frozen_string_literal: true
FactoryGirl.define do
  factory :how_to_sub_category do
    name { Faker::Lorem.sentence }
    parent_category { 0 }
  end
end
