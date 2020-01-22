module PagesHelper
  def user_has_request?
    current_user.friend_requests.where(to_user_id: current_user.id, status: "none").any?
  end

  def user_signed_in_redirect
    unless user_signed_in?
      flash[:danger] = "You must be signed in to visit this page."
      redirect_to root_url
    end
  end

  def get_digest(string)
    Digest::MD5.hexdigest(string).truncate(10, omission: '')
  end
end
