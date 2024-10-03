require "rails_helper"

RSpec.describe Picture, type: :model do
  describe "validations" do
    subject { create(:picture) }

    it { is_expected.to validate_presence_of(:image_url) }
  end

  describe "validation" do
    context "when normal" do
      it "is valid with an image_url" do
        picture = build(:picture)
        expect(picture).to be_valid
      end
    end

    context "when abnormal" do
      it "is invalid without an image_url" do
        picture = build(:picture, image_url: nil)
        expect(picture).not_to be_valid
      end

      it "is invalid without a theme_id" do
        picture = build(:picture, theme_id: nil)
        expect(picture).not_to be_valid
      end

      it "is invalid without a frame_id" do
        picture = build(:picture, frame_id: nil)
        expect(picture).not_to be_valid
      end
    end
  end

  describe "association" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:theme) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:like_users).through(:likes).source(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
