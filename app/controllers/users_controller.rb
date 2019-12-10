class UsersController < ApplicationController
  before_action :user_signed_in_check

  def index

  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @requests = current_user.friend_requests if user_has_request?
  end
end
