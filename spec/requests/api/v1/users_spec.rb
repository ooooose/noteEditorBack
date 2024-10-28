require "rails_helper"

RSpec.describe User, type: :request do
  describe "POST /auth/google/callback" do
    context "when valid request" do
      before do
        user_params = attributes_for(:user)
        post "/auth/google/callback", params: { user: user_params }
      end

      it "creates a new user" do
        expect(response).to have_http_status(:ok)
      end

      it "return accessToken" do
        expect(JSON.parse(response.body)["accessToken"]).to be_present
      end
    end

    context "when invalid request" do
      before do
        post "/auth/google/callback", params: { user: { email: "", name: "" } }
      end

      it "returns internal_server_error status" do
        expect(response).to have_http_status(:internal_server_error)
      end

      it "returns error messages" do
        expect(JSON.parse(response.body)["error"]).to include("ログインに失敗しました")
      end
    end
  end

  describe "GET /api/v1/users/me" do
    let!(:user) { create(:user) }
    let!(:token) { encode_jwt({ user_id: user.id }) }
    let!(:headers) { { Authorization: "Bearer #{token}" } }

    context "when valid request" do
      before do
        get "/api/v1/users/me", headers: headers
      end
      
      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns current_user data" do
        expect(JSON.parse(response.body)["data"]["attributes"]["email"]).to eq(user.email)
      end
    end
    context "when invalid request" do
      before do
        get "/api/v1/users/me"
      end

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        expect(JSON.parse(response.body)["error"]).to include("Not Authorized")
      end
    end
  end

  describe "PATCH /api/v1/users/profile" do
    let!(:user) { create(:user) }
    let!(:token) { encode_jwt({ user_id: user.id }) }
    let!(:headers) { { Authorization: "Bearer #{token}" } }

    context "when valid request without image" do
      before do
        patch "/api/v1/users/profile", params: { user: { name: "new_name" } }, headers: headers
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the user" do
        expect(User.find(user.id).name).to eq("new_name")
      end
    end

    context "when valid request with image" do
      before do
        patch "/api/v1/users/profile", params: { user: { name: "new_name", image: "files/test.jpg" } }, headers: headers
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the user" do
        expect(User.find(user.id).name).to eq("new_name")
      end
    end

    context "when valid request without name" do
      before do
        patch "/api/v1/users/profile", params: { user: { image: "files/test.jpg" } }, headers: headers
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the user" do
        expect(User.find(user.id).image).to eq("files/test.jpg")
      end 
    end

    context "when invalid request" do
      before do
        patch "/api/v1/users/profile", params: { user: { name: nil } }, headers: headers
      end

      it "returns internal_server_error status" do
        expect(response).to have_http_status(:internal_server_error)
      end

      it "returns error messages" do
        expect(JSON.parse(response.body)["error"]).to include("プロフィールの更新に失敗しました")
      end
    end
  end
end
