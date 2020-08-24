# frozen_string_literal: true

FactoryGirl.define do
  factory :faq do
    question { Faker::Lorem.sentence }
    answer { Faker::Lorem.paragraph(3) }
    category { 0 }
    faq_type
    faq_category
  end
end
