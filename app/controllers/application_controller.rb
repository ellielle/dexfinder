class ApplicationController < ActionController::Base
  include PagesHelper
  include LikesHelper
  include Pagy::Backend
end
