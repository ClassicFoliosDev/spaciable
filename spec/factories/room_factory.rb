# frozen_string_literal: true
FactoryGirl.define do
  factory :room do
    sequence :name do |n|
      "Bedroom #{n}"
    end
    unit_type
  end
end
