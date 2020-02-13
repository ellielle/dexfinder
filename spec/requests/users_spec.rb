require 'rails_helper'
require 'support/database_cleaner'
require 'support/test_helpers'

RSpec.describe "User tests" do
  before do
    @current_user = FactoryBot.create(:user)
    @other_user = create_other_user
    @friend_request = FactoryBot.create(:friend_request, from_user_id: @other_user.id,
                      to_user_id: @current_user.id)
    sign_in(@current_user)
  end

  context "when accepting/denying friend requests" do
    it "adds the other user as a friend when accepted" do
      expect(@current_user.incoming_friend_requests.empty?).to be_falsey
      expect(@friend_request.status).to eq("none")
      get self_profile_path
      expect(response).to have_http_status(200)
      post friends_path, xhr: true, params: { commit: "Accept", request_id: @friend_request.id}
      expect(response).to have_http_status(200)
      expect(FriendRequest.find(@friend_request.id).status).to eq("accepted")
    end

    it "declines the invitation when declined" do
      expect(@current_user.incoming_friend_requests.empty?).to be_falsey
      expect(@friend_request.status).to eq("none")
      get self_profile_path
      expect(response).to have_http_status(200)
      post friends_path, xhr: true, params: { commit: "Decline", request_id: @friend_request.id}
      expect(response).to have_http_status(200)
      expect(FriendRequest.find(@friend_request.id).status).to eq("declined")
    end
  end

  context "when sending a friend request" do
    it "does not allow duplicate requests regardless of which user initially sent the request" do
      FriendRequest.destroy_all
      # First FriendRequest should work properly
      expect(@current_user.incoming_friend_requests.empty?).to be_truthy
      get self_profile_path
      expect(response).to have_http_status(200)
      post friend_request_path, params: { request_friend_id: @other_user.id }
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include("Friend request sent.")
      expect(FriendRequest.first).to have_attributes(to_user_id: @other_user.id,
                                                               from_user_id: @current_user.id)
      expect(FriendRequest.count).to eq(1)
      # Second attempt to send a FriendRequest should fail
      post friend_request_path, params: { request_friend_id: @other_user.id }
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(CGI.unescape_html(response.body)).to include("You can't send multiple requests to the same person.")
      expect(FriendRequest.count).to eq(1)
      sign_out(@current_user)
      sign_in(@other_user)
      # It should also not allow the other User to send a request to the first User
      post friend_request_path, params: { request_friend_id: @current_user.id }
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(CGI.unescape_html(response.body)).to include("Friend request already exists.")
      expect(FriendRequest.count).to eq(1)
    end
  end
end