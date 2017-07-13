# frozen_string_literal: true
FactoryGirl.define do
  factory :appliance_categories_manufacturer do
    appliance_category
    appliance_manufacturer
  end
end
