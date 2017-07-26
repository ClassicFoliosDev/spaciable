# frozen_string_literal: true
FactoryGirl.define do
  factory :private_document do
    sequence :title do |n|
      "Document #{n}"
    end
  end
end
