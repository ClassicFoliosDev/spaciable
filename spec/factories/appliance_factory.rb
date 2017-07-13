# frozen_string_literal: true
FactoryGirl.define do
  factory :appliance do
    sequence :model_num do |n|
      " #{n}"
    end
    sequence :name do |n|
      "Appliance from manufacturer #{n}"
    end
    appliance_category
    appliance_manufacturer
  end
end
