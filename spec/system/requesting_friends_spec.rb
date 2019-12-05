require 'rails_helper'

RSpec.describe "RequestingFriends", type: :system do
  before do
    driven_by(:rack_test)
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  describe "navigating to profile page" do
    it "should allow user into their profile page" do
      get profile_url
      expect(response).to have_http_status(200)
    end

    it "should redirect user from profile page if not signed in" do
      sign_out @user
      get profile_url
      expect(response).to have_http_status(302)
    end
  end
end
