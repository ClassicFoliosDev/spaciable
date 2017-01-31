# frozen_string_literal: true
FactoryGirl.define do
  factory :contact do
    email { Faker::Internet.email }
  end
end
