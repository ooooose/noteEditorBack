require "rails_helper"

RSpec.describe Like, type: :model do
  describe "validations" do
    subject { create(:like) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:picture_id) }
  end

  describe "validation" do
    context "when normal" do
      it "is valid with a user_id and picture_id" do
        like = build(:like)
        expect(like).to be_valid
      end
    end
    context "when abnormal" do
      it "is invalid without a user_id" do
        like = build(:like, user_id: nil)
        expect(like).not_to be_valid
      end
      it "is invalid without a picture_id" do
        like = build(:like, picture_id: nil)
        expect(like).not_to be_valid
      end
    end
  end
  
  describe "association" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:picture) }
  end
end
