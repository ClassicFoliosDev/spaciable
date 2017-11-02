# frozen_string_literal: true

FactoryGirl.define do
  factory :homeowner_login_content do
    title_left { Faker::Lorem.sentence }
    title_right { Faker::Lorem.sentence }
    blurb_para_1 { Faker::Lorem.paragraph }
    blurb_para_2 { Faker::Lorem.paragraph }
  end
end
