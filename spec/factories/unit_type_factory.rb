# frozen_string_literal: true

FactoryGirl.define do
  factory :unit_type do
    sequence :name do |n|
      "#{n} Bed"
    end
    development
  end
end
