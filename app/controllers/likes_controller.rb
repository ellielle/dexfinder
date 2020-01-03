class LikesController < ApplicationController
  before_action :user_signed_in?
  before_action :already_liked?, only: :create

  def create

  end

  def destroy

  end

  private

  def already_liked?
    Like.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end
end
