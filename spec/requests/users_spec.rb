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
    sign_in(@current_user)
  end

  context "when accepting/denying friend requests" do
    it "adds the other use as a friend when accepted" do
      expect(@current_user.friend_requests.empty?).to be_falsey
      expect(@friend_request.status).to eq("none")
      get profile_path
      expect(response).to have_http_status(200)
      post friends_path, xhr: true, params: { commit: "Accept", request_id: @friend_request.id}
      expect(response).to have_http_status(200)
      expect(FriendRequest.find(@friend_request.id).status).to eq("accepted")
    end

    it "declines the invitation when declined" do
      expect(@current_user.friend_requests.empty?).to be_falsey
      expect(@friend_request.status).to eq("none")
      get profile_path
      expect(response).to have_http_status(200)
      post friends_path, xhr: true, params: { commit: "Decline", request_id: @friend_request.id}
      expect(response).to have_http_status(200)
      expect(FriendRequest.find(@friend_request.id).status).to eq("declined")
    end
  end
end