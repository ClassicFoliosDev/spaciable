# frozen_string_literal: true

FactoryGirl.define do
  factory :resident_notification do
    resident
    notification
  end
end
