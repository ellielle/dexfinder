class PostsController < ApplicationController
  before_action :user_signed_in_redirect
  before_action :get_forwarding_url, only: [:show, :update]
  before_action :correct_user?, only: [:edit, :update, :destroy]

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
    @pagy, @posts = pagy(Post.all, items: 10)
  end

  def show
    @post = post_slug
    @is_liked = already_liked?(@post.id) ? "liked" : "not-liked" if @post
    slug_redirect
  end

  def edit
    @post = post_slug
    slug_redirect
  end

  def update
    @post = post_slug
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to post_path(@post)
    else
      flash[:warning] = "You broke something. Fix it."
      redirect_back_or(posts_url)
    end
  end

  def destroy
    Post.find_by(slug: params[:slug]).destroy
    flash[:success] = "Post deleted."
    redirect_to posts_url
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :user_id)
  end

  def correct_user?
    redirect_back(fallback_location: posts_url) unless post_slug.user == current_user
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
