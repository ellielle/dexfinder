FactoryBot.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { "testing12" }

    trait :user2 do
      username { Faker::Internet.user_name }
      email { Faker::Internet.email }
      password { "totallynotuser1" }
    end
  end
end
