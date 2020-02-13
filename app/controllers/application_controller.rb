class ApplicationController < ActionController::Base
  include PagesHelper
  include LikesHelper
  #rescue_from ActionView::Template::Error, with: :i_am_bad # FIXME

  private

  def i_am_bad
    flash[:danger] = "Page not found. Redirected home."
    redirect_to root_url
  end
end
