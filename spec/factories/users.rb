FactoryBot.define do
  factory :user do
    id { 1 }
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { "testing12" }

    trait :user2 do
      id { 2 }
      username { Faker::Internet.user_name }
      email { Faker::Internet.email }
      password { "totallynotuser1" }
    end
  end
end
