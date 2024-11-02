require "rails_helper"

RSpec.describe "Api::V1::Themes", type: :request do
  let(:user) { create(:user) }
  let(:token) { encode_jwt({ user_id: user.id }) }
  let(:headers) { { Authorization: "Bearer #{token}" } }

  describe "GET /api/v1/themes" do
    before { create_list(:theme, 3) }

    context "when the user gets the themes" do
      before { get api_v1_themes_path, headers: }

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns themes" do
        expect(JSON.parse(response.body)["data"].length).to eq(3)
      end
    end

    context "when unauthorized" do
      before { get api_v1_themes_path }

      it "returns status unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
