require 'rails_helper'
require 'support/database_cleaner_capy'

RSpec.configure do |config|
  config.after :each do
    Warden.test_reset!
  end
end

RSpec.describe "Requesting Friends" do
  before do
    Capybara.current_driver = :rack_test
    @current_user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, username: Faker::Internet.user_name,
                                    email: "test@testytest.com",
                                    password: "boopsie")
    login_as(@current_user, scope: :user)
  end

  xdescribe "navigating to profile page and accepting invitation" do
    it "should allow user to use profile page" do
      FactoryBot.create(:friend_request, from_user_id: @other_user.id,
                        to_user_id: @current_user.id)
      visit self_profile_path
      #expect(page.status_code).to eq(200)
      expect(page).to have_current_path(self_profile_path)
      expect(page).to have_css("#pending-incoming-requests")
        #click_button("Accept")
      #ensure none are left
      # TODO rewrite test after implement fix for jquery not removing the div
      #visit self_profile_path
        #click_button("Accept")
      #reset test / requests?
      #navigate back
      #click decline button for each requests
      #ensure none are left
    end

    it "should redirect user to root page if not signed in" do
      logout
      visit self_profile_path
      #expect(page.status_code).to eq(200)
      expect(page).to have_current_path(root_path)
      expect(page).to_not have_css("#pending-incoming-requests")
    end
  end
end
