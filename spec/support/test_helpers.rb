def create_posts
  FactoryBot.create(:post, title: "testing this post", body: "hi i'm testing the body",
                    user_id: @current_user.id)
  FactoryBot.create(:post, title: "also hi", body: "also testing body", user_id: @current_user.id)
end

def create_one_post
  FactoryBot.create(:post, title: "testing this post", body: "hi i'm testing the body",
                    user_id: @current_user.id)
end

def create_other_user
  FactoryBot.create(:user, username: Faker::Internet.user_name,
                                  email: "test@testytest.com",
                                  password: "boopsie")
end