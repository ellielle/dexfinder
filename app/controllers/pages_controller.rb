class PagesController < ApplicationController
  def index
    remove_me if Rails.env.development?
  end

  def remove_me
    #TODO REMOVE ME
    FriendRequest.find(4).update(status: "none")
    FriendRequest.find(6).update(status: "none")
  end
end
