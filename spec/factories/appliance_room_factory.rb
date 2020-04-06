# frozen_string_literal: true

FactoryGirl.define do
  factory :appliance_room do
    appliance
    room
    added_by{"CF Admin"}
  end
end
