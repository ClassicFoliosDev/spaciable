# frozen_string_literal: true
FactoryGirl.define do
  factory :developer do
    company_name { Faker::Company.name }
    email { Faker::Internet.email }
    contact_number { "+44 #{Faker::Number.number(9)}" }
    about { Faker::Lorem.paragraph(3) }

    trait :with_residents do
      after(:create) do |developer|
        development = create(:development, developer: developer)

        create_list(:plot, 3, :with_resident, development: development)
      end
    end

    trait :with_phase_residents do
      after(:create) do |developer|
        development = create(:development, developer: developer)
        phase = create(:phase, development: development)
        create_list(:phase_plot, 3, :with_resident, phase: phase)
      end
    end
  end
end
