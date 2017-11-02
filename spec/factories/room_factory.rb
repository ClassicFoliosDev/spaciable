# frozen_string_literal: true

FactoryGirl.define do
  factory :room do
    sequence :name do |n|
      "Bedroom #{n}"
    end
    unit_type

    factory :plot_room do
      unit_type_id { nil }
      plot
    end
  end
end
