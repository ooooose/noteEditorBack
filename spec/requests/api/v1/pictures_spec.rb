require "rails_helper"

RSpec.describe "Api::V1::Pictures", type: :request do
  let!(:user) { create(:user) }
  let!(:token) { encode_jwt({ user_id: user.id }) }
  let!(:headers) { { Authorization: "Bearer #{token}" } }
  let!(:theme) { create(:theme) }

  describe "GET /api/v1/pictures" do
    context "when the user does not have any pictures" do
      before { get api_v1_pictures_path, headers: }

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty array" do
        expect(JSON.parse(response.body)["pictures"]["data"].length).to eq(0)
      end
    end

    context "when the user has pictures" do
      before do
        create_list(:picture, 3, user:)
        get api_v1_pictures_path, headers:
      end

      it "returns stattus ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns pictures" do
        expect(JSON.parse(response.body)["pictures"]["data"].length).to eq(3)
      end
    end

    context "when the user has soft destroyed pictures" do
      before do
        create_list(:picture, 3, user:)
        Picture.last.soft_destroy
        get api_v1_pictures_path, headers:
      end

      it "returns pictures without soft destroyed ones" do
        expect(JSON.parse(response.body)["pictures"]["data"].length).to eq(2)
      end
    end

    context "when unauthenticated" do
      before { get api_v1_pictures_path }

      it "returns status unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/pictures" do
    context "when params are valid" do
      it "creates a picture and return status created" do
        post(api_v1_pictures_path,
             params: { picture: { image_url: "https://test.com" }, title: theme.title }, headers:)
        expect(response).to have_http_status(:created)
      end

      it "returns the created picture" do
        post(api_v1_pictures_path,
             params: { picture: { image_url: "https://test.com" }, title: theme.title }, headers:)
        expect(JSON.parse(response.body)["data"]["image_url"]).to be_nil
      end
    end

    context "when params are invalid" do
      it "returns errors without image_url" do
        post(api_v1_pictures_path, params: { picture: { title: theme.title } }, headers:)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors without theme_id" do
        post(api_v1_pictures_path,
             params: { picture: { image_url: "https://test.com" } }, headers:)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when unauthenticated" do
      it "returns status unauthorized" do
        post(api_v1_pictures_path,
             params: { picture: { image_url: "https://test.com", title: theme.title } })
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/pictures/top" do
    context "when there are pictures" do
      before do
        create_list(:picture, 8, user:)
        get "/api/v1/pictures/top"
      end

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns top pictures" do
        expect(JSON.parse(response.body)["data"].length).to eq(6)
      end
    end
  end

  describe "PATCH /api/v1/pictures/:id/switch_frame" do
    context "when the picture exists" do
      let!(:picture) { create(:picture, user:, frame_id: 0) }
      params = { picture: { frame_id: 1 } }

      subject do
        patch "/api/v1/pictures/#{picture.id}/switch_frame", params:, headers:
      end

      it "returns status ok" do
        expect(picture.frame_id).to eq(0)
        subject
        expect(response).to have_http_status(:ok)
        expect(picture.reload.frame_id).to eq(1)
      end
    end
  end
end
