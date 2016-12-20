# frozen_string_literal: true
FactoryGirl.define do
  factory :phase do
    sequence :name do |n|
      "Phase #{n}"
    end
    address
    development
  end
end
