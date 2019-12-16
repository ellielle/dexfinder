require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction
RSpec.configure do |config|
  config.after :each do
    Warden.test_reset!
  end
end

RSpec.describe "RequestingFriends", type: :system do
  before do
    driven_by(:rack_test)
    DatabaseCleaner.start
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
  end

  after do
    DatabaseCleaner.clean
  end

  describe "navigating to profile page and accepting invitation" do
    it "should allow user to use profile page" do
      FactoryBot.create(:user, :user2)
      FactoryBot.create(:friend_request)
      visit profile_url
      expect(page.status_code).to eq(200)
      expect(page).to have_current_path(profile_path)
      expect(page).to have_css("#pending-incoming-requests")
      #click accept button for each request
      #ensure none are left
      #reset test / requests?
      #navigate back
      #click decline button for each request
      #ensure none are left
    end

    it "should redirect user to root page if not signed in" do
      logout
      visit profile_url
      expect(page.status_code).to eq(200)
      expect(page).to have_current_path(root_path)
      expect(page).to_not have_css("#pending-incoming-requests")
    end
  end
end
