require 'rails_helper'

RSpec.describe User, type: :model do
  describe "when test users are created" do
    it "should be valid user" do
      user = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user, :user2)
      expect(user).to be_valid
      expect(user2).to be_valid
    end
  end
end
