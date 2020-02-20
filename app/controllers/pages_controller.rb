class PagesController < ApplicationController
  def index
    @posts = Post.take(10)
  end
end
