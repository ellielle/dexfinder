class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user, :post)
  end
end
