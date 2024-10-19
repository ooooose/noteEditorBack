require "rails_helper"

RSpec.describe "Api::V1::Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:theme) { create(:theme) }
  let!(:picture) { create(:picture, theme:) }
  let!(:token) { encode_jwt({ user_id: user.id }) }
  let!(:headers) { { Authorization: "Bearer #{token}" } }

  describe "POST api/v1/likes" do
    context "when the user likes the picture with valid params" do
      before { post api_v1_likes_path, params: { picture_uid: picture.uid }, headers: }

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a message" do
        expect(JSON.parse(response.body)["message"]).to eq("Liked the picture")
      end
    end

    context "when the user likes the picture with invalid params" do
      before { post api_v1_likes_path, params: { picture_uid: nil }, headers: }

      it "returns status not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE api/v1/likes/:picture_uid" do
    context "when the user unlikes the picture with valid params" do
      before { delete api_v1_like_path(picture.uid), headers: }

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a message" do
        expect(JSON.parse(response.body)["message"]).to eq("Unliked the picture")
      end
    end

    context "when the user unlikes the picture with invalid params" do
      before { delete api_v1_like_path("not-found"), headers: }

      it "returns status not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
