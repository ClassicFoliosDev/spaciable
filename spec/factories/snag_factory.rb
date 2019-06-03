FactoryGirl.define do
  factory :snag do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(3) }
    plot_id { 1 }
  end
end