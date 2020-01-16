FactoryBot.define do
  factory :user, aliases: [:to_user, :from_user] do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { "testing12" }
  end
end
