module PagesHelper
  def user_has_request?
    true if current_user.friend_requests.any?
    false
  end
end
