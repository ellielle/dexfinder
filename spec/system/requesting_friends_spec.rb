require 'rails_helper'
require 'database_cleaner'

RSpec.configure do |config|
  config.after :each do
    Warden.test_reset!
  end
end

RSpec.describe "Requesting Friends" do
  before do
    Capybara.current_driver = :rack_test
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
  end

  describe "navigating to profile page and accepting invitation" do
    it "should allow user to use profile page" do
      FactoryBot.create(:user, :user2)
      FactoryBot.create(:friend_request)
      visit profile_url
      expect(page.status_code).to eq(200)
      expect(page).to have_current_path(profile_path)
      expect(page).to have_css("#pending-incoming-requests")
      #click_button("Accept")
      #ensure none are left
      # TODO rewrite test after implement fix for jquery not removing the div
      #visit profile_path
        #click_button("Accept")
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
