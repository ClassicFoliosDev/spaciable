# frozen_string_literal: true

FactoryGirl.define do
  factory :development do
    name { "#{Faker::Company.name.delete('-').delete(',').delete("'")} Development" }
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

    trait :with_activated_residents do
      transient do
        plots_count 3
      end

      after(:create) do |development, evaluator|
        create_list(:plot, evaluator.plots_count, :with_activated_resident, development: development)
      end
    end
  end
end
