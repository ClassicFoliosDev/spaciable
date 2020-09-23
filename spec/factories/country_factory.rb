# frozen_string_literal: true

FactoryGirl.define do
  factory :country do
    name { "UK" }
    time_zone { "London" }
  end
end
