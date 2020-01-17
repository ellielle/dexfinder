require 'rails_helper'
require 'support/database_cleaner'
require 'support/test_helpers'

RSpec.describe "Comment tests" do
  before do
    @current_user = FactoryBot.create(:user)
    @other_user = create_other_user
    sign_in(@current_user)
  end

  context "when creating a new top-level comment" do
    it "doesn't allow invalid comments" do
      # Valid comment
      post = create_one_post
      expect(post.comments.count).to eq(0)
      get post_path(post)
      expect(response).to have_http_status(200)
      post post_comments_path(post), params: { comment: { body: "wow this is a great post", user_id: @other_user.id,
                                                    post_id: post.id }}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("wow this is a great post")
      expect(post.comments.count).to eq(1)
      # Invalid comment
      get post_path(post)
      expect(response).to have_http_status(200)
      post post_comments_path(post), params: { comment: { user_id: @other_user.id, post_id: post.id }}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(post.comments.count).to eq(1)
    end
  end

  context "when creating a reply to a comment" do
    it "doesn't allow invalid comments" do
      post = create_one_post
      expect(post.comments.count).to eq(0)
      get post_path(post)
      expect(response).to have_http_status(200)
      # Create initial top-level comment
      post post_comments_path(post), params: { comment: { body: "wow this is a great post", user_id: @other_user.id,
                                                             post_id: post.id }}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("wow this is a great post")
      expect(post.comments.count).to eq(1)
      # Create a reply to top-level comment
      post comment_comments_path(post), params: { comment: { body: "wow your comment is so good", user_id: @other_user.id,
                                                             comment_id: post.comments.first.id }}
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("wow your comment is so good")
      expect(post.comments.count).to eq(2)
    end
  end

end