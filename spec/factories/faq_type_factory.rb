# frozen_string_literal: true

FactoryGirl.define do
  factory :faq_type do
    name { "Homeowner" }
    construction_type
    country
  end
end
