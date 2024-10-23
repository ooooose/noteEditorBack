require "rails_helper"

RSpec.describe "Api::V1::Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:picture) { create(:picture) }
  let!(:token) { encode_jwt({ user_id: user.id }) }
  let!(:headers) { { Authorization: "Bearer #{token}" } }

  describe "POST api/v1/pictures/:picture_id/comments" do
    context "when the user comments the picture with valid params" do
      before {
        post api_v1_picture_comments_path(picture_id: picture.id),
             params: { comment: { body: "test", picture_id: picture.id } }, headers:
      }

      it "returns status created" do
        expect(response).to have_http_status(:created)
      end

      it "returns a message" do
        expect(JSON.parse(response.body)["message"]).to eq("Commented the picture")
      end
    end

    context "when the user comments the picture with invalid params" do
      before {
        post api_v1_picture_comments_path(picture_id: picture.id), params: {
                                                                     comment: { body: nil, picture_id: picture.id },
                                                                   },
                                                                   headers:
      }

      it "returns status unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE api/v1/pictures/:picture_id/comments/:id" do
    let!(:comment) { create(:comment, user:, picture:) }

    context "when the user deletes the comment with valid params" do
      before { delete api_v1_picture_comment_path(picture_id: picture.id, id: comment.id), headers: }

      it "returns status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a message" do
        expect(JSON.parse(response.body)["message"]).to eq("Comment was successfully deleted")
      end
    end

    context "when the user deletes the comment with invalid params" do
      before { delete api_v1_picture_comment_path(picture_id: picture.id, id: 0), headers: }

      it "returns status not_found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
