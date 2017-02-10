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

    trait :with_resident do
      after(:create) do |plot|
        create(:resident, plots: [plot])
      end
    end
  end
end
