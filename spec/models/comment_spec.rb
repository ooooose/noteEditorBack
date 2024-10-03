require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "validation" do
    context "when normal" do
      it "is valid with a content" do
        comment = build(:comment)
        expect(comment).to be_valid
      end
    end

    context "when abnormal" do
      it "is invalid without a body" do
        comment = build(:comment, body: nil)
        expect(comment).not_to be_valid
      end

      it "is invalid without a user_id" do
        comment = build(:comment, user_id: nil)
        expect(comment).not_to be_valid
      end

      it "is invalid without a picture_id" do
        comment = build(:comment, picture_id: nil)
        expect(comment).not_to be_valid
      end
    end
  end
end
