require 'rails_helper'
require 'support/database_cleaner'
require 'support/test_helpers'

RSpec.describe "User tests" do
  before do
    @current_user = FactoryBot.create(:user)
    @other_user = create_other_user
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

    it "redirects users not logged in when trying to post" do
      expect(Post.all.count).to eq(0)
      sign_out(@current_user)
      get new_post_path
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("You must be signed in")
      post posts_path, params: { post: { title: "OI", body: "THIS IS A POST", user_id: @current_user.id }}
      expect(response).to have_http_status(302)
    end

    it "doesn't allow invalid posts" do
      expect(Post.all.count).to eq(0)
      get new_post_path
      expect(response).to have_http_status(200)
      post posts_path, params: { post: { body: "THIS IS A POST", user_id: @current_user.id }}
      expect(response.body).to include("1 error prohibited this post")
      post posts_path, params: { post: { title: "OI", user_id: @current_user.id }}
      expect(response.body).to include("2 errors prohibited this post")
      post posts_path, params: { post: { user_id: @current_user.id }}
      expect(response.body).to include("3 errors prohibited this post")
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
      post = create_one_post
      expect(Post.all.count).to be(1)
      get post_path(post)
      expect(response).to have_http_status(200)
      expect(response.body).to include(post.title)
                                   .and include(@current_user.username)
                                   .and include('id="like-count">0</small>')
    end
  end

  context "when deleting posts" do
    it "only allows the post author to delete" do
      # User isn't post's creator
      post = create_one_post
      sign_out(@current_user)
      sign_in(@other_user)
      get post_path(post)
      expect(response).to have_http_status(200)
      delete post_path(post)
      expect(response).to have_http_status(302)
      expect(Post.all.count).to eq(1)
      sign_out(@other_user)
      # Post creator can delete the post
      sign_in(@current_user)
      delete post_path(post)
      expect(response).to have_http_status(302)
      expect(Post.all.count).to eq(0)
      follow_redirect!
      expect(response.body).to include("Post deleted.")
    end
  end

  context "when creating posts" do
    it "only allows logged in users to create posts" do
      # Logged in user
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
      # User isn't logged in
      get new_post_path
      expect(response).to have_http_status(302)
      post posts_path, params: { post: { title: "test title",
                                         body: "testing body",
                                         user_id: @current_user.id }}
      expect(response).to have_http_status(302)
      expect(Post.all.count).to eq(1)
    end
  end

  context "when editing/updating a post" do
    it "only allows the proper user to edit their post" do
      # User is post's creator
      FactoryBot.create(:post, user_id: @current_user.id)
      expect(Post.all.count).to eq(1)
      get edit_post_path(Post.first)
      expect(response).to have_http_status(200)
      expect(response.body).to include("test-page-testing")
      patch post_path(Post.first), params: { post: { title: "bip bop",
                                          body: "bibbity boop",
                                          user_id: @current_user.id }}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("Post updated.").and include("bibbity boop")
      sign_out(@current_user)
      # User is not post's creator
      sign_in(@other_user)
      get edit_post_path(Post.first)
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("bip bop")
    end
  end
end