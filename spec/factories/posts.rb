FactoryBot.define do
  factory :post do
    body { "test-page-testing" }
    title { Faker::Cannabis.strain }
    user_id { 1 }
  end
end
