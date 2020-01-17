require 'rails_helper'
require 'support/database_cleaner'

def create_posts
  FactoryBot.create(:post, title: "testing this post", body: "hi i'm testing the body",
                    user_id: @current_user.id)
  FactoryBot.create(:post, title: "also hi", body: "also testing body", user_id: @current_user.id)
end

RSpec.describe "Comment tests" do
  before do
    @current_user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, username: Faker::Internet.user_name,
                                    email: "test@testytest.com",
                                    password: "boopsie")
    sign_in(@current_user)
  end

  xcontext "when creating a new comment" do
    it "" do
      create_posts
    end
  end

end