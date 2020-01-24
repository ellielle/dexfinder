class CommentsController < ApplicationController
  before_action :user_signed_in_redirect
  before_action :find_commentable, only: [:create, :destroy]
  after_action :update_comment_count, only: [:create, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    if @commentable.comments.create(comment_params)
      redirect_back_or(post_path(@commentable))
    else
      flash[:danger] = "Something went wrong, please set your computer on fire to solve the issue."
      redirect_to @commentable.nil? ? root_url : post_path(@commentable)
    end
  end

  def destroy
    if @commentable.user == current_user
      @commentable.update(body: "[deleted]") unless @commentable.nil?
      redirect_back(fallback_location: posts_path)
    else
      flash[:danger] = "You can't do that."
      redirect_back(fallback_location: posts_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

  def find_commentable
    if params[:comment][:post_id]
      @commentable = Post.find(params[:comment][:post_id])
    elsif params[:comment][:comment_id]
      @commentable = Comment.find(params[:comment][:comment_id])
    end
  end

  def update_comment_count
    if request.request_method == "POST"
      @commentable.update(comment_count:  @commentable.comment_count + 1)
    elsif request.request_method == "DELETE"
      post = Post.find_by(slug: request.referrer.rpartition(/\//)[2])
      post.update(comment_count: post.comment_count - 1) unless post.comment_count <= 0
    end
  end
end
