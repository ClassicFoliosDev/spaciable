# frozen_string_literal: true

FactoryGirl.define do
  factory :default_faq do
    question { Faker::Lorem.sentence }
    answer { Faker::Lorem.paragraph(3) }
    category { 0 }
    country_id  { 1 }
    faq_type
    faq_category
  end
end
