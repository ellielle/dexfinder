FactoryBot.define do
  factory :post do
    body { "test-page-testing" }
    title { Faker::Cannabis.strain }
    user_id { 1 }
    comment_count { 0 }
  end
end
