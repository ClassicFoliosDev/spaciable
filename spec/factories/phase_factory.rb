# frozen_string_literal: true

FactoryGirl.define do
  factory :phase do
    sequence :name do |n|
      "Phase #{n}"
    end
    development

    trait :with_address do
      after(:create) do |development|
        create(:address, addressable: development)
      end
    end

    trait :with_activated_residents do
      after(:create) do |phase|
        create_list(:phase_plot, 3, :with_activated_resident, phase: phase)
      end
    end
  end
end
