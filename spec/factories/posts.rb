FactoryBot.define do
  factory :post do
    id { 1 }
    body { "test-page-testing" }
    user_id { 1 }
  end
end
