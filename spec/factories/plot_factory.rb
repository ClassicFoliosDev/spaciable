# frozen_string_literal: true

FactoryGirl.define do
  factory :plot do
    sequence :number do |n|
      n
    end
    unit_type
    development

    factory :phase_plot do
      development { nil }
      phase
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
      end
    end
  end
end
