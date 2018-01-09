# frozen_string_literal: true

FactoryGirl.define do
  factory :development_message do
    subject { Faker::Lorem.words(4).join(" ") }
    content { Faker::Lorem.words(10).join(" ") }
  end
end
