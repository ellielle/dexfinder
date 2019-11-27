module PagesHelper
  def user_has_request?
    current_user.friend_requests.any?
  end
end
