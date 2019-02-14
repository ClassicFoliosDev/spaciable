# frozen_string_literal: true

FactoryGirl.define do
  factory :how_to do
    title { Faker::Lorem.sentence }
    summary { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(3) }
    category { 0 }
    country_id { 1 }
  end

  trait :with_tag do
    after(:create) do |how_to|
      tag = create(:tag)
      how_to.tags << tag
    end
  end
end
