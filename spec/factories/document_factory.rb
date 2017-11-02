# frozen_string_literal: true

FactoryGirl.define do
  factory :document do
    sequence :title do |n|
      "Document #{n}.pdf"
    end
  end
end
