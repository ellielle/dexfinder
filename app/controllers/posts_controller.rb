class PostsController < ApplicationController
  before_action :user_signed_in_redirect
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
    @posts = Post.all
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
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:body, :user_id)
  end

  def correct_user?
    post_slug.user == current_user
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
