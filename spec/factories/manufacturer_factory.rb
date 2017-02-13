# frozen_string_literal: true
FactoryGirl.define do
  factory :manufacturer do
    sequence :name do |n|
      "Manufacturer #{n}"
    end
  end
end
