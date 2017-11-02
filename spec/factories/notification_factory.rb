# frozen_string_literal: true

FactoryGirl.define do
  factory :notification do
    send_to { |notification| notification.association(:developer) }
    sent_at { Time.zone.now }
    subject { Faker::Lorem.words(5).join(" ") }
    message { Faker::Lorem.paragraph(3) }
    sender { |notification| notification.association(:developer_admin) }
  end
end
