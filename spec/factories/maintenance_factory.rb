FactoryGirl.define do
  factory :maintenance do
    development_id { 1 }
    path { "https://brillianthomes.fixflo.com/issue/plugin" }
    account_type { "standard" }
  end
end