class UsersController < ApplicationController
  before_action :user_signed_in_redirect

  def index

  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  end

  def friends
    if params[:request_id]
      friend_request_action
      redirect_back(fallback_location: self_profile_path)
    end
  end

  def friend_request
    send_friend_request(params[:request_friend_id]) if params[:request_friend_id]
    redirect_back(fallback_location: self_profile_path)
  end

  def profile
    @requests = get_friend_requests if user_has_request?
    @friends = get_friend_list
    @not_friends = get_not_friends
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
    current_user.friend_requests.where(status: "none").where.not(from_user_id: current_user.id).all
  end

  def get_not_friends
    # Get Users current_user has requests with, then compare against rest of Users
    list = [current_user.id]
    current_user.friend_requests.each do |request|
      if request.to_user_id != current_user.id
        list << request.to_user_id unless list.include?(request.to_user_id)
      elsif request.from_user_id != current_user.id
        list << request.from_user_id unless list.include?(request.from_user_id)
      end
    end
    get_not_friends_list(list)
  end

  def get_not_friends_list(list)
    User.where.not(id: list)
  end

  def process_request(answer)
    answer ? FriendRequest.update(params[:request_id], status: "accepted") :
        FriendRequest.update(params[:request_id], status: "declined")
  end

  def change_user_avatar
    if current_user.avatar.attached?
      current_user.avatar.purge
    end
    current_user.avatar.attach(params[:avatar])
    # TODO use user.avatar.purge to delete previous image before storing a different one
    # TODO ^ but check to make sure one is attached first
  end

  def send_friend_request(id)
    FriendRequest.create(to_user_id: id, from_user_id: current_user.id)
  end
end
