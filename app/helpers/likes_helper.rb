module LikesHelper
  def already_liked?(post_id)
    Like.where(user_id: current_user.id, post_id: post_id).exists?
  end
end
