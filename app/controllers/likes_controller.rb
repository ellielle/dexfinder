class LikesController < ApplicationController
  before_action :user_signed_in?
  before_action :find_post

  def create
    unless already_liked?(params[:post_id])
      @post.likes.create
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy

  end

  private

  def like_params

  end

  def find_post
    @post = Post.find_by(slug: params[:post_slug])
  end
end

# TODO disable button after a like / dislike and don't re-enable it until after the query completes
# might need to use a create.js.erb file to re-render modal?