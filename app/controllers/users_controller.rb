class UsersController < ApplicationController
  before_action :user_signed_in_redirect

  def index

  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @requests = get_friend_requests if user_has_request?
    @friends = get_friend_list
  end

  def update

  end

  def friends
    @requests = get_friend_requests if user_has_request?
    @friends = get_friend_list
    friend_request_action if params[:request_id]
    respond_to do |format|
      format.js
    end
  end

  private

  def friend_request_action
    if params[:request_id] && params[:commit] == "Accept"
      process_request(true)
    elsif params[:request_id] && params[:commit] == "Decline"
      process_request(false)
    end
  end

  def get_friend_list
    current_user.friend_requests.where(status: "accepted").all
  end

  def get_friend_requests
    current_user.friend_requests.where(status: "none").all
  end

  def process_request(answer)
    answer ? FriendRequest.update(params[:request_id], status: "accepted") :
        FriendRequest.update(params[:request_id], status: "declined")
  end
end
