require 'rails_helper'
require 'support/database_cleaner'

def create_posts
  FactoryBot.create(:post, title: "testing this post", body: "hi i'm testing the body",
                    user_id: @current_user.id)
  FactoryBot.create(:post, title: "also hi", body: "also testing body", user_id: @current_user.id)
end

RSpec.describe "User tests" do
  before do
    @current_user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, username: Faker::Internet.user_name,
                                    email: "test@testytest.com",
                                    password: "boopsie")
    sign_in(@current_user)
  end

  context "when creating posts" do
    it "allows logged in user to make a post" do
      expect(Post.all.count).to eq(0)
      get new_post_path
      expect(response).to have_http_status(200)
      post posts_path, params: { post: { title: "OI", body: "THIS IS A POST", user_id: @current_user.id }}
      expect(redirect_to(post_path(Post.first)))
      expect(Post.all.count).to eq(1)
    end

    it "redirects users not logged in" do
      expect(Post.all.count).to eq(0)
      sign_out(@current_user)
      get new_post_path
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("You must be signed in")
      post posts_path, params: { post: { title: "OI", body: "THIS IS A POST", user_id: @current_user.id }}
      expect(response).to have_http_status(302)
    end
  end

  context "when showing posts" do
    it "shows all posts on post#index" do
      create_posts
      expect(Post.all.count).to be(2)
      get posts_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(Post.first.title)
                                   .and include(Post.last.title)
                                   .and include(@current_user.username)
                                   .and include("0 comments")
    end

    it "shows the right post and all poster information" do
      create_posts
      expect(Post.all.count).to be(2)
      get post_path(Post.last)
      expect(response).to have_http_status(200)
      expect(response.body).to include(Post.last.title)
                                   .and include(@current_user.username)
                                   .and include('id="like-count">0</small>')
    end
  end

  context "when deleting posts" do
    it "only allows the post author to delete" do
      FactoryBot.create(:post, title: "testing this post", body: "hi i'm testing the body",
                        user_id: @current_user.id)
      sign_out(@current_user)
      sign_in(@other_user)
      get post_path(Post.first)
      expect(response).to have_http_status(200)
      delete post_path(Post.first)
      expect(response).to have_http_status(302)
      expect(Post.all.count).to eq(1)
      sign_out(@other_user)
      sign_in(@current_user)
      delete post_path(Post.first)
      expect(response).to have_http_status(302)
      expect(Post.all.count).to eq(0)
      follow_redirect!
      expect(response.body).to include("Post deleted.")
    end
  end

  context "when creating posts" do
    it "only allows logged in users to create posts" do
      expect(Post.all.count).to eq(0)
      get new_post_path
      expect(response).to have_http_status(200)
      post posts_path, params: { post: { title: "test title",
                                         body: "testing body",
                                         user_id: @current_user.id }}
      expect(Post.all.count).to eq(1)
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("test title")
      sign_out(@current_user)
      get new_post_path
      expect(response).to have_http_status(302)
      post posts_path, params: { post: { title: "test title",
                                         body: "testing body",
                                         user_id: @current_user.id }}
      expect(response).to have_http_status(302)
    end
  end

  xcontext "when editing/updating a post" do
    it "only allows the proper user to edit their post" do

    end
  end
end