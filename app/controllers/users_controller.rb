class UsersController < ApplicationController
  before_action :user_signed_in_redirect

  def index
  end

  def show
    if params[:username]
      @user = User.find_by(username: params[:username])
    elsif params[:id]
      @user = User.find_by(id: params[:id])
    end
    @pagy, @posts = pagy(@user.posts) unless @user.nil?
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  end

  def friends
    # :request_id refers to the FriendRequest ID
    if params[:request_id]
      friend_request_action
      redirect_back(fallback_location: self_profile_path)
    end
  end

  def friend_request
    # :request_friend_id refers to the receiving User's ID
    send_friend_request(params[:request_friend_id]) if params[:request_friend_id]
    redirect_back(fallback_location: self_profile_path)
  end

  def friend_delete
    remove_friend if params[:delete_friend_id]
    redirect_to self_profile_path
  end

  def profile
    @requests = get_friend_requests if user_has_request?
    @friends = get_friend_list
    @potential_friends = get_potential_friend_list
    @user = current_user
    @pagy, @posts = pagy(current_user.posts, items: 10)
  end

  def upload
    change_user_avatar
  end

  private

  def user_params
    params.require(:user).permit(:email, :avatar)
  end

  def friend_request_action
    if params[:request_id] && params[:commit] == "Accept"
      process_request(true)
    elsif params[:request_id] && params[:commit] == "Decline"
      process_request(false)
    end
  end

  def get_friend_list
    FriendRequest.joins(:to_user, :from_user)
        .where("to_user_id = ? OR from_user_id = ?", current_user.id, current_user.id)
        .filter{ |request| request.status == "accepted" }
  end

  def get_friend_requests
    current_user.incoming_friend_requests.where(status: "none")
  end

  def get_potential_friend_list
    # Get Users current_user has requests with, then compare against rest of Users
    user_ids = User.ids.reject{ |reject_id| reject_id == current_user.id }
        .difference(current_user.outgoing_friend_requests.map { |friend| friend.to_user_id })
        .difference(current_user.incoming_friend_requests.map { |friend| friend.from_user_id })
    User.where(id: user_ids)
  end

  def process_request(accept)
    accept ? FriendRequest.update(params[:request_id], status: "accepted") :
        FriendRequest.update(params[:request_id], status: "declined")
  end

  def change_user_avatar
    if params[:avatar].nil?
      flash[:warning] = "Attachment can't be empty"
      redirect_to self_profile_path
    else
      if current_user.avatar.attach(params[:avatar])
        redirect_to self_profile_path
      else
        flash[:danger] = "#{current_user.errors.full_messages[0].gsub(/[\"\[\]]/, '')}"
        redirect_to self_profile_path
      end
    end
  end

  def send_friend_request(user_id)
    friend_request = current_user.outgoing_friend_requests.build(to_user_id: user_id)
    begin
      if friend_request.save
        flash[:success] = "Friend request sent."
      else
        flash[:danger] = "You can't send multiple requests to the same person."
      end
    rescue ActiveRecord::RecordNotUnique
      # Using a 'non-Railsy' way to enforce unique constraints without throwing an error. Doing it at the model level
      # doesn't seem to prevent RecordNotUnique errors, and I couldn't find much on interchangeable unique fields.
      flash[:danger] = "Friend request already exists."
    end
  end

  def remove_friend
    FriendRequest.find(params[:delete_friend_id]).destroy
  end
end
