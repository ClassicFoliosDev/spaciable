# frozen_string_literal: true

FactoryGirl.define do
  factory :finish do
    sequence :name do |n|
      "Finish #{n}"
    end
    finish_category
    finish_type
  end
end
