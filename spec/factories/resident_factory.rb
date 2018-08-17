# frozen_string_literal: true

FactoryGirl.define do
  factory :resident do
    email { "resident." + Faker::Internet.email }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { "0300 200 3300" }

    trait :activated do
      after(:create) do |resident|
        resident.developer_email_updates = true
        resident.ts_and_cs_accepted_at = Time.zone.now
        resident.save!
      end
    end

    trait :with_residency do
      transient do
        plot
      end

      after(:create) do |resident, evaluator|
        resident.plots << evaluator.plot
        resident.save!

        plot_residency = resident.plot_residencies.first
        plot_residency.role = 'homeowner'
        plot_residency.save!
      end
    end

    trait :with_tenancy do
      transient do
        plot
      end

      after(:create) do |resident, evaluator|
        resident.plots << evaluator.plot
        resident.save!

        plot_residency = resident.plot_residencies.first
        plot_residency.role = 'tenant'
        plot_residency.save!
      end
    end
  end
end
