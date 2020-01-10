class LikesController < ApplicationController
  before_action :user_signed_in?
  before_action :find_post

  def create
    if already_liked?(@post.id)
      destroy
    else
      if @post.likes.create(user_id: current_user.id, post_id: @post.id)
        flash.now[:success] = "work"
      else
        flash.now[:danger] = "nope"
      end
    end
  end

  def destroy
    @post.likes.find_by(user_id: current_user.id, post_id: @post.id).destroy
  end

  def set_likes
    respond_to do |format|
      format.js
    end
  end

  private

  def find_post
    @post = Post.find_by(slug: params[:post_slug])
  end
end
