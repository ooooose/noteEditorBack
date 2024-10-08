require "rails_helper"

RSpec.describe "Api::V1::Pictures", type: :request do
  let!(:user) { create(:user) }
  let!(:token) { encode_jwt({ user_id: user.id }) }
  let!(:headers) { { Authorization: "Bearer #{token}" } }

  describe "GET /api/v1/pictures" do
    context "when the user does not have any pictures" do
      before { get api_v1_pictures_path, headers: }

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty array" do
        expect(JSON.parse(response.body)["data"].length).to eq(0)
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
        expect(JSON.parse(response.body)["data"].length).to eq(3)
      end
    end
  end
end
