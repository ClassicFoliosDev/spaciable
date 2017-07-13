# frozen_string_literal: true
FactoryGirl.define do
  factory :appliance_manufacturer do
    sequence :name do |n|
      "Appliance manufacturer #{n}"
    end
  end
end
