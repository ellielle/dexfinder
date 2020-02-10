module PagesHelper
  def user_has_request?
    # TODO
    # TODO
    # TODO
    # TODO fix the friend_request relationship changes, THROW IT ALL IN THE FIRE AND START OVER
    # FIXME : this is causing most of the test failures. START HERE
    #  might require completely rework of logic
    # FIXME | work done yesterday
    current_user.incoming_friend_requests.where(status: "none").any?
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

  def get_forwarding_url
    session[:forwarding_url] = request.original_url
  end

  def redirect_back_or(default_location)
    redirect_to(session[:forwarding_url] || default_location)
    session.delete(:forwarding_url)
  end

  def user_has_avatar?(user)
    if user.avatar.attached?
      user.avatar
    else
      "empty_avatar.png"
    end
  end
end
