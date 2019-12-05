module PagesHelper
  def user_has_request?
    current_user.friend_requests.any?
  end

  def user_signed_in_check
    flash[:danger] = "You must be signed in to visit this page."
    redirect_to root_url unless user_signed_in?
  end
end
