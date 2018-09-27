# frozen_string_literal: true

FactoryGirl.define do
  factory :plot do
    sequence :number do |n|
      n
    end
    unit_type
    development
    completion_date { Faker::Date.forward(3) }
    address

    factory :phase_plot do
      development { nil }
      phase
      completion_date { Faker::Date.forward(3) }
    end

    trait :with_activated_resident do
      transient do
        resident { build(:resident) }
      end

      after(:create) do |plot, evaluator|
        resident = evaluator.resident
        plot.residents << resident
        resident.developer_email_updates = true
        resident.save!

        plot_residency = resident.plot_residencies.first
        plot_residency.role = :homeowner
        plot_residency.save!
      end
    end

    trait :with_resident do
      transient do
        resident { build(:resident) }
      end

      after(:create) do |plot, evaluator|
        resident = evaluator.resident
        plot.residents << resident
        resident.save!

        plot_residency = resident.plot_residencies.first
        plot_residency.role = :homeowner
        plot_residency.save!
      end
    end
  end
end
