FactoryBot.define do
  factory :post do
    body { "test-page-testing" }
    likes { 0 }
    user_id { 1 }
  end
end
