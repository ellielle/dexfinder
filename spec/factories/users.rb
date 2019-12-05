FactoryBot.define do
  factory :user do
    id { 1 }
    username { "testy" }
    email { "example@email.com" }
    password { "testing12" }

    trait :user2 do
      id { 2 }
      username { "user2" }
      email { "fake@user.com" }
      password { "totallynotuser1" }
    end
  end
end
