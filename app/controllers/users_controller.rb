class UsersController < ApplicationController
  before_action :user_signed_in_redirect
  after_confirmation :set_

  def index

  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = current_user.id
  end

  def update

  end

  def friends
    if params[:request_id]
      friend_request_action
      redirect_back(fallback_location: self_profile_path)
    end
  end

  def profile
    @requests = get_friend_requests if user_has_request?
    @friends = get_friend_list
    # TODO get user avatar if exists
    #@avatar
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

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
