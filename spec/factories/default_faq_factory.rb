# frozen_string_literal: true
FactoryGirl.define do
  factory :default_faq do
    question { Faker::Lorem.sentence }
    answer { Faker::Lorem.paragraph(3) }
    category { :settling }
  end
end
