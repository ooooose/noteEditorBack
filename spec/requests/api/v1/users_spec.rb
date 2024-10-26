require "rails_helper"

RSpec.describe User, type: :request do
  describe "POST /auth/google/callback" do
    context "when valid request" do
      it "creates a new user and returns accessToken" do
        user_params = attributes_for(:user)
        post "/auth/google/callback", params: { user: user_params }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["user"]["email"]).to eq(user_params[:email])
        expect(JSON.parse(response.body)["accessToken"]).to be_present
      end
    end

    context "when invalid request" do
      it "returns internal_server_error status" do
        post "/auth/google/callback", params: { user: { email: "", name: "" } }
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)["error"]).to include("ログインに失敗しました")
      end
    end
  end
end
