FactoryBot.define do
  factory :friend_request do
    from_user_id { 2 }
    to_user_id { 1 }
  end
end
