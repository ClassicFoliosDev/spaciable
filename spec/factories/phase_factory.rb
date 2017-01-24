# frozen_string_literal: true
FactoryGirl.define do
  factory :phase do
    sequence :name do |n|
      "Phase #{n}"
    end
    address
    development

    trait :with_residents do
      after(:create) do |phase|
        create_list(:phase_plot, 3, phase: phase).each do |plot|
          create(:homeowner, plots: [plot])
        end
      end
    end
  end
end
