class UsersController < ApplicationController
  before_action :user_signed_in_check

  def index

  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @friend_requests = current_user.friend_requests if user_has_request?
    respond_to do |format|
      format.html
      format.js
    end
    end
=begin
  def update
    respond_to do |format|
      if params[:commit] == "Accept"
        format.html { redirect_to root_url }
        format.js
      elsif params[:commit] == "Decline"
        format.js
      end

    end
  end
=end
end
