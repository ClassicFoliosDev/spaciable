# frozen_string_literal: true
FactoryGirl.define do
  factory :finish_category do
    sequence :name do |n|
      "Finish Category #{n}"
    end
  end
end
