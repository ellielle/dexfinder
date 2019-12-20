class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def index
    @posts = Post.all
  end

  def get_post
    @post = Post.find(params[:current_post])
    respond_to do |format|
      format.js
    end
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

  def post_params
    params.require(:post).permit(:body, :user_id)
  end

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
