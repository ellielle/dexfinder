class UsersController < ApplicationController
  before_action :user_signed_in_check

  def index

  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @requests = get_friend_requests if user_has_request?
    @friends = get_friend_list
    friend_request_action if params[:request_id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update

  end

  private

  def friend_request_action
    if params[:request_id] && params[:commit] == "Accept"
      accept_request
    elsif params[:request_id] && params[:commit] == "Decline"
      decline_request
    end
  end

  def get_friend_list
    current_user.friend_requests.where(status: "accepted").all
  end

  def get_friend_requests
    current_user.friend_requests.where(status: "none").all
  end

  def accept_request
    FriendRequest.update(params[:request_id], status: "accepted")
  end

  def decline_request
    FriendRequest.update(params[:request_id], status: "declined")
  end
end
