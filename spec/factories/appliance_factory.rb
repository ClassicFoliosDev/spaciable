# frozen_string_literal: true

FactoryGirl.define do
  factory :appliance do
    sequence :model_num do |n|
      " #{n}"
    end
    appliance_category
    appliance_manufacturer
    added_by {"tester"}
  end
end
