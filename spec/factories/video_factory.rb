# frozen_string_literal: true
FactoryGirl.define do
  factory :video do
    title { Faker::Lorem.sentence }
    link { "http://videos.com/dummy_link" }
  end
end
