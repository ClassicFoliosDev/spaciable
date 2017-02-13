# frozen_string_literal: true
FactoryGirl.define do
  factory :appliance_category do
    sequence :name do |n|
      "Appliance Category #{n}"
    end
  end
end
