require 'rails_helper'
require 'database_cleaner'

RSpec.describe "Pages tests" do
  describe "navigating static pages" do
    it "should redirect if not logged in when navigating away from index" do
      get root_url
      expect(response).to have_http_status(200)
      get profile_path
      expect(response).to have_http_status(302)
      get posts_path
      expect(response).to have_http_status(302)
      get new_post_path
      expect(response).to have_http_status(302)
      get new_comment_path
      expect(response).to have_http_status(302)
    end

    it "should not redirect if logged in" do
      sign_in(FactoryBot.create(:user))
      get root_url
      expect(response).to have_http_status(200)
      get profile_path
      expect(response).to have_http_status(200)
      get posts_path
      expect(response).to have_http_status(200)
      get new_post_path
      expect(response).to have_http_status(200)
      get new_comment_path
      expect(response).to have_http_status(200)
    end
  end
end