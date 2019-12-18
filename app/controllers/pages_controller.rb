class PagesController < ApplicationController
  def index
    @posts = Post.all
  end

  def remove_me
    #TODO REMOVE ME
    FriendRequest.find(4).update(status: "none")
    FriendRequest.find(6).update(status: "none")
  end
end
