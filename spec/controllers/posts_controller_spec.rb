require 'rails_helper'

RSpec.describe PostsController do
  include Devise::Test::ControllerHelpers
  before do
    sign_in(FactoryBot.create(:user))
    FactoryBot.create(:post)
  end

  describe "GET #new" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { slug: "totally-real-page" }
      expect(response).to have_http_status(:redirect)
      get :show, params: { slug: "test-page-testing" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      allow(controller).to receive(:correct_user?).and_return(true)
      get :edit, params: { slug: "totally-real-page" }
      expect(response).to have_http_status(:redirect)
      get :edit, params: { slug: "test-page-testing" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
