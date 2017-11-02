# frozen_string_literal: true

FactoryGirl.define do
  factory :brand do
    banner { Rack::Test::UploadedFile.new(Rails.root.join("features", "support", "files", "cala_banner.jpg")) }
  end
end
