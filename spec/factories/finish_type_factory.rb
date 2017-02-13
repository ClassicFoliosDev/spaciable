# frozen_string_literal: true
FactoryGirl.define do
  factory :finish_type do
    sequence :name do |n|
      "Finish Type #{n}"
    end
  end
end
