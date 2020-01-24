require 'rails_helper'
require 'support/database_cleaner'
require 'support/test_helpers'

RSpec.describe "Comment tests" do
  before do
    @current_user = FactoryBot.create(:user)
    @other_user = create_other_user
    sign_in(@current_user)
    @post = create_one_post
  end

  context "when creating a new top-level comment" do
    it "doesn't allow invalid comments" do
      # Valid comment
      expect(@post.comments.count).to eq(0)
      get post_path(@post)
      expect(response).to have_http_status(200)
      post comments_path(@post), params: { comment: { body: "wow this is a great post", user_id: @other_user.id,
                                                    post_id: @post.id }}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("wow this is a great post")
      expect(@post.comments.count).to eq(1)
      # Invalid comment
      get post_path(@post)
      expect(response).to have_http_status(200)
      post comments_path(@post), params: { comment: { user_id: @other_user.id, post_id: @post.id }}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(@post.comments.count).to eq(1)
    end
  end

  context "when creating a reply to a comment" do
    it "doesn't allow invalid comments" do
      expect(@post.comments.count).to eq(0)
      get post_path(@post)
      expect(response).to have_http_status(200)
      # Create initial top-level comment
      post comments_path(@post), params: { comment: { body: "wow this is a great post", user_id: @other_user.id,
                                                      post_id: @post.id }},
           headers: { "HTTP_REFERER": "http://example.com/posts/#{@post.slug}" }
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("wow this is a great post")
      expect(@post.comments.count).to eq(1)
      # Create a reply to top-level comment
      post comments_path(@post), params: { comment: { body: "wow your comment is so good", user_id: @other_user.id,
                                                      comment_id: @post.comments.first.id }},
           headers: { "HTTP_REFERER": "http://example.com/posts/#{@post.slug}" }
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("wow your comment is so good")
      expect(@post.comments.count).to eq(1)
      expect(Comment.all.count).to eq(2)
    end
  end

  context "when deleting comments" do
    it "only allows comment poster to delete" do
      # Incorrect User can't delete comment
      get post_path(@post)
      expect(response).to have_http_status(200)
      post comments_path(@post), params: { comment: { body: "wow this is a great post", user_id: @current_user.id,
                                                      post_id: @post.id }},
           headers: { "HTTP_REFERER": "http://example.com/posts/#{@post.slug}" }
      post comments_path(@post), params: { comment: { body: "wow your comment is so good", user_id: @current_user.id,
                                                      comment_id: @post.comments.first.id }},
           headers: { "HTTP_REFERER": "http://example.com/posts/#{@post.slug}" }
      expect(Comment.all.count).to eq(2)
      sign_out(@current_user)
      sign_in(@other_user)
      get post_path(@post)
      expect(response).to have_http_status(200)
      expect(response.body).to include("wow this is a great post")
      delete comment_path(Comment.first), params: { comment: { post_id: @post.id }},
             headers: { "HTTP_REFERER": "http://example.com/posts/#{@post.slug}" }
      follow_redirect!
      expect(Comment.all.count).to eq(2)
      expect(response.body).to_not include("[deleted]")
      # Correct User can delete comment
      sign_out(@other_user)
      sign_in(@current_user)
      # Deletes only the child comment
      delete comment_path(Comment.first), params: { comment: { comment_id: @post.comments.first.comments.first.id }},
             headers: { "HTTP_REFERER": "http://example.com/posts/#{@post.slug}" }
      expect(Comment.all.count).to eq(2)
      get post_path(@post)
      expect(response.body).to include("[deleted]")
    end
  end
end