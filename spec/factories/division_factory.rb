# frozen_string_literal: true
FactoryGirl.define do
  factory :division do
    developer
    email { Faker::Internet.email }
    division_name { Faker::Company.name }
    contact_number { "+44 #{Faker::Number.number(9)}" }

    trait :with_residents do
      transient do
        plots_count 3
      end

      after(:create) do |division, evaluator|
        development = create(:division_development, division: division)
        create_list(:plot, evaluator.plots_count, :with_resident, development: development)
      end
    end

    trait :with_phase_residents do
      transient do
        plots_count 3
      end

      after(:create) do |division, evaluator|
        development = create(:division_development, division: division)
        phase = create(:phase, development: development)
        create_list(:phase_plot, evaluator.plots_count, :with_resident, phase: phase)
      end
    end
  end
end
