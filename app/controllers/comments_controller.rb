class CommentsController < ApplicationController
  before_action :user_signed_in_redirect
  before_action :find_commentable, only: [:create, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    if @commentable.comments.create(comment_params)
      redirect_back(fallback_location: @commentable.nil? ? root_url : post_path(@commentable))
    else
      flash[:danger] = "Something went wrong, please set your computer on fire to solve the issue."
      redirect_to @commentable.nil? ? root_url : post_path(@commentable)
    end
  end

  def destroy
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
end
