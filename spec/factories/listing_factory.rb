# frozen_string_literal: true

FactoryGirl.define do
  factory :listing do
     reference { Faker::Lorem.word }
     other_ref { Faker::Lorem.word }
     owner { 'admin' }
  end
end