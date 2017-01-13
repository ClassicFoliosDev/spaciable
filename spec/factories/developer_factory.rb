# frozen_string_literal: true
FactoryGirl.define do
  factory :developer do
    company_name { Faker::Company.name }
    email { Faker::Internet.email }
    contact_number { "+44 #{Faker::Number.number(9)}" }
    about { Faker::Lorem.paragraph(3) }
  end
end
