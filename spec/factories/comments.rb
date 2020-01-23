FactoryBot.define do
  factory :comment do
    body { "This is a test comment" }
    commentable_id { 0 }
    commentable_type { "Post" }
    user_id { 0 }
  end
end
