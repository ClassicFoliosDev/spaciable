# frozen_string_literal: true
FactoryGirl.define do
  factory :appliance do
    sequence :model_num do |n|
      " #{n}"
    end
    sequence :name do |n|
      "Category manufacturer #{n}"
    end
    appliance_category
    manufacturer
  end
end
