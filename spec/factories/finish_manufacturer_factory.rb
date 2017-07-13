# frozen_string_literal: true
FactoryGirl.define do
  factory :finish_manufacturer do
    sequence :name do |n|
      "Finish manufacturer #{n}"
    end
  end
end
