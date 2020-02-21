module PostsHelper
  def users_are_friends?(user)
    return true if FriendRequest
           .where("to_user_id = :tuid AND from_user_id = :fuid AND status = 'accepted'", tuid: current_user.id, fuid: user.id)
           .or(FriendRequest
           .where("to_user_id = :tuid AND from_user_id = :fuid AND status = 'accepted'", tuid: user.id, fuid: current_user.id))
           .exists?
    false
  end
end
