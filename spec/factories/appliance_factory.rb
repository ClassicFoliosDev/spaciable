# frozen_string_literal: true
FactoryGirl.define do
  factory :appliance do
    sequence :name do |n|
      "Washing Machine #{n}"
    end
  end
end
