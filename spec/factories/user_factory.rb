# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    factory :cf_admin do
      role { :cf_admin }
    end

    factory :developer_admin do
      role { :developer_admin }
      permission_level { |user| user.association(:developer) }
    end

    factory :division_admin do
      role { :division_admin }
      permission_level { |user| user.association(:division) }
    end

    factory :development_admin do
      role { :development_admin }
      permission_level { |user| user.association(:development) }
    end

    factory :homeowner do
      role { :homeowner }
    end
  end
end
