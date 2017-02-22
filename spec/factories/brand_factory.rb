# frozen_string_literal: true
FactoryGirl.define do
  factory :brand do
    banner { Rack::Test::UploadedFile.new(File.join(Rails.root, "features", "support", "files", "cala_banner.jpg")) }
  end
end
