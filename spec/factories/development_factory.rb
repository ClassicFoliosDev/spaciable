# frozen_string_literal: true
FactoryGirl.define do
  factory :development do
    name { "#{Faker::Company.name} Development" }
    email { Faker::Internet.email }
    contact_number { "+44 #{Faker::Number.number(9)}" }

    address
    developer
  end
end
