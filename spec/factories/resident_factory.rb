# frozen_string_literal: true
FactoryGirl.define do
  factory :resident do
    email { "resident." + Faker::Internet.email }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :with_residency do
      transient do
        plot
      end

      after(:create) do |resident, evaluator|
        resident.plot = evaluator.plot
        resident.save!
      end
    end
  end
end
