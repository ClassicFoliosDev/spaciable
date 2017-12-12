# frozen_string_literal: true

FactoryGirl.define do
  factory :brand do
    logo { Rack::Test::UploadedFile.new(Rails.root.join('features', 'support', 'files', 'bovis_logo.png')) }
    banner { Rack::Test::UploadedFile.new(Rails.root.join("features", "support", "files", "cala_banner.jpg")) }
  end
end
