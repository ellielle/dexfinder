require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  before do
    FactoryBot.create(:user)
    FactoryBot.create(:post)
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
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
