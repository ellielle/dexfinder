class CommentsController < ApplicationController
  before_action :user_signed_in_redirect
  before_action :find_commentable, only: [:create, :destroy]
  after_action :increase_comment_count, only: :create
  after_action :decrease_comment_count, only: :destroy

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
    # Using @commentable_type to make it easier to find the post of child comments
    if params[:comment][:post_id]
      @commentable = Post.find(params[:comment][:post_id])
      @commentable_type = "Post"
    elsif params[:comment][:comment_id]
      @commentable = Comment.find(params[:comment][:comment_id])
      @commentable_type = "Comment"
    end
  end

  def increase_comment_count
    update_comment_count(1)
  end

  def decrease_comment_count
    update_comment_count(-1)
  end

  def update_comment_count(amount_changed)
    if @commentable_type == "Post"
      Post.update_counters(@commentable.id, comment_count: amount_changed)
    elsif @commentable_type == "Comment"
      find_post_id = Post.includes(:comments).where(comments: { body: @commentable.body }).map { |post| post.id }
      Post.update_counters(find_post_id, comment_count: amount_changed)
    end
  end
end
