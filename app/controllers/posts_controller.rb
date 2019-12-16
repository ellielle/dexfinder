class PostsController < ApplicationController
  def new
  end

  def create
  end

  def index
  end

  def show
    @post = Post.find_by(slug: params[:slug])
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
