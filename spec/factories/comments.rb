FactoryBot.define do
  factory :comment do
    body { "MyText" }
    commentable_id { 0 }
    commentable_type { "Post" }
    user_id { 0 }
  end
end
