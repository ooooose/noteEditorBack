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
end
