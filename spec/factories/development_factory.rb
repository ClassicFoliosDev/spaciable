# frozen_string_literal: true
FactoryGirl.define do
  factory :development do
    name { "#{Faker::Company.name} Development" }
    email { Faker::Internet.email }
    contact_number { "+44 #{Faker::Number.number(9)}" }

    address
    developer
    division { nil }

    factory :division_development do
      developer { nil }
      division
    end

    trait :with_address do
      after(:create) do |development|
        create(:address, addressable: development)
      end
    end

    trait :with_residents do
      after(:create) do |development|
        create_list(:plot, 3, :with_resident, development: development)
      end
    end
  end
end
