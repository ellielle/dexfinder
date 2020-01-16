require 'rails_helper'
require 'support/database_cleaner'

RSpec.describe "User tests" do
  before do
    @current_user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, username: Faker::Internet.user_name,
                                    email: "test@testytest.com",
                                    password: "boopsie")
    @friend_request = FactoryBot.create(:friend_request, from_user_id: @other_user.id,
                      to_user_id: @current_user.id)
  end

  describe "friend requests" do
    it "can accept or decline friend requests" do
      sign_in(@current_user)
      get profile_path
      expect(@current_user.friend_requests.empty?).to be_falsey
      expect(@friend_request.status).to eq("none")
      expect(response).to have_http_status(200)
      post friends_path, xhr: true, params: { commit: "Accept", request_id: @friend_request.id}
      expect(response).to have_http_status(200)
      expect(FriendRequest.find(@friend_request.id).status).to eq("accepted")
    end
  end
end