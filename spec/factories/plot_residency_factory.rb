# frozen_string_literal: true

FactoryGirl.define do
  factory :plot_residency do
    resident
    plot
    completion_date { Faker::Date.forward(3) }
  end
end
