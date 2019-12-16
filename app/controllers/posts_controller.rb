class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
  end

  def index
  end

  def show
    @post = post_slug
    slug_redirect
  end

  def edit
    @post = post_slug
    slug_redirect
  end

  def update
  end

  def destroy
  end

  private

  def post_slug
    Post.find_by(slug: params[:slug])
  end

  def slug_redirect
    unless @post
      flash[:warning] = "This page does not exist."
      redirect_back(fallback_location: root_url)
    end
  end
end
