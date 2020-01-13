FactoryBot.define do
  factory :post do
    id { 1 }
    body { "test-page-testing" }
    title { Faker::Cannabis.strain }
    user_id { 1 }
  end
end
