# frozen_string_literal: true
FactoryGirl.define do
  factory :division do
    developer
    email { Faker::Internet.email }
    division_name { Faker::Company.name }
    contact_number { "+44 #{Faker::Number.number(9)}" }

    trait :with_residents do
      after(:create) do |division|
        development = create(:division_development, division: division)
        create_list(:plot, 3, development: development).each do |plot|
          create(:homeowner, plots: [plot])
        end
      end
    end

    trait :with_phase_residents do
      after(:create) do |division|
        development = create(:division_development, division: division)
        phase = create(:phase, development: development)
        create_list(:phase_plot, 3, :with_resident, phase: phase)
      end
    end
  end
end
