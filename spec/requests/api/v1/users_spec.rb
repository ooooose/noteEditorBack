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
    let(:user) { create(:user) }
    let(:token) { encode_jwt({ user_id: user.id }) }
    let(:headers) { { Authorization: "Bearer #{token}" } }

    context "when valid request" do
      before do
        get "/api/v1/users/me", headers:
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

  describe "PUT /api/v1/users/profile" do
    let!(:user) { create(:user) }
    let!(:token) { encode_jwt({ user_id: user.id }) }
    let!(:headers) { { Authorization: "Bearer #{token}" } }

    context "when valid request without image" do
      before do
        put "/api/v1/users/profile", params: { user: { name: "new_name" } }, headers:
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the user" do
        expect(described_class.find(user.id).name).to eq("new_name")
      end
    end

    context "when valid request with image" do
      before do
        put "/api/v1/users/profile", params: { user: { name: "new_name", image: "files/test.jpg" } }, headers:
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the user" do
        expect(described_class.find(user.id).name).to eq("new_name")
      end
    end

    context "when valid request without name" do
      before do
        put "/api/v1/users/profile", params: { user: { image: "files/test.jpg" } }, headers:
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the user" do
        expect(described_class.find(user.id).image).to eq("files/test.jpg")
      end
    end

    context "when invalid request" do
      before do
        put "/api/v1/users/profile", params: { user: { name: nil } }, headers:
      end

      it "returns internal_server_error status" do
        expect(response).to have_http_status(:internal_server_error)
      end

      it "returns error messages" do
        expect(JSON.parse(response.body)["error"]).to include("プロフィールの更新に失敗しました")
      end
    end
  end

  describe "GET /api/v1/users/:id/pictures" do
    let!(:user) { create(:user) }
    let!(:token) { encode_jwt({ user_id: user.id }) }
    let!(:headers) { { Authorization: "Bearer #{token}" } }
    let!(:theme) { create(:theme) }

    before do
      create_list(:picture, 3, user:, theme:)
      get "/api/v1/users/#{user.uid}/pictures", headers:
    end

    context "when valid request" do
      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns pictures" do
        expect(JSON.parse(response.body)["pictures"]["data"].length).to eq(3)
      end
    end

    context "when unauthorized request" do
      before do
        get "/api/v1/users/#{user.uid}/pictures"
      end

      it "returns unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/users/:id/liked_pictures" do
    let(:user) { create(:user) }
    let(:token) { encode_jwt({ user_id: user.id }) }
    let(:headers) { { Authorization: "Bearer #{token}" } }
    let(:theme) { create(:theme) }
    let!(:picture) { create(:picture, theme:) }

    before do
      create(:like, user:, picture:)
    end

    context "when valid request" do
      before do
        get "/api/v1/users/#{user.uid}/liked_pictures", headers:
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns pictures" do
        expect(JSON.parse(response.body)["pictures"]["data"].length).to eq(1)
      end
    end

    context "when has soft destroyed pictures" do
      before do
        picture.update!(deleted_at: Time.current)
      end

      it "returns status ok" do
        get("/api/v1/users/#{user.uid}/liked_pictures", headers:)
        expect(response).to have_http_status(:ok)
      end

      it "returns no pictures" do
        get("/api/v1/users/#{user.uid}/liked_pictures", headers:)
        expect(JSON.parse(response.body)["pictures"]["data"].length).to eq(0)
      end
    end

    context "when unauthorized request" do
      before do
        get "/api/v1/users/#{user.uid}/liked_pictures"
      end

      it "returns not_fouunauthorizednd status" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/pictures/top" do
    let!(:top_user) { create(:user) }
    let!(:second_user) { create(:user) }
    let!(:third_user) { create(:user) }
    let!(:non_top_user) { create(:user) }

    context "when there are pictures" do
      before do
        create_list(:picture, 8, user: top_user)
        create_list(:picture, 5, user: second_user)
        create_list(:picture, 3, user: third_user)
        create_list(:picture, 1, user: non_top_user)
        get "/api/v1/users/top"
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns top 3 users" do
        expect(JSON.parse(response.body)["data"].length).to eq(3)
      end

      it "returns top user in order" do
        expect(JSON.parse(response.body)["data"][0]["id"]).to eq(top_user.id.to_s)
      end

      it "returns third user in order" do
        expect(JSON.parse(response.body)["data"][2]["id"]).to eq(third_user.id.to_s)
      end
    end
  end
end
