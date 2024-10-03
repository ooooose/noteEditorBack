require "rails_helper"

RSpec.describe Theme, type: :model do
  describe "validations" do
    subject { create(:theme) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  describe "validation" do
    context "when normal" do
      it "is valid with a title" do
        theme = build(:theme)
        expect(theme).to be_valid
      end
    end

    context "when abnormal" do
      it "is invalid without a title" do
        theme = build(:theme, title: nil)
        expect(theme).not_to be_valid
      end
    end
  end

  describe "association" do
    it { is_expected.to have_many(:pictures).dependent(:destroy) }
  end
end
