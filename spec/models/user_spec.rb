require "rails_helper"

RSpec.describe User, type: :model do
  # validationのテスト
  describe "validation" do
    context "when normal" do
      # 名前とメールアドレスがあれば、有効であること
      it "is valid with a name and email" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context "when abnormal" do
      # 名前がなければ、無効であること
      it "is invalid without a name" do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
      end

      # メールアドレスがなければ、無効であること
      it "is invalid without a email" do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
      end

      # 重複したメールアドレスなら無効であること
      it "is invalid with a duplicate email address" do
        create(:user, email: "test@gmail.com")
        user = build(:user, email: "test@gmail.com")
        expect(user).not_to be_valid
      end
    end
  end

  # associationのテスト
  describe "association" do
    it { is_expected.to have_many(:pictures).dependent(:destroy) }
  end

  # クラスメソッドのテスト
  describe ".find_with_jwt" do
    let!(:user) { create(:user) }
    let!(:secret_key) { Rails.application.credentials.secret_key_base }
    let!(:token) do
      JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, secret_key, "HS256")
    end

    context "when the token is valid" do
      it "finds a user" do
        expect(described_class.find_with_jwt(token)).to eq user
      end
    end

    context "when the token is invalid" do
      let!(:invalid_token) { "invalid_token" }

      it "does not find a user" do
        expect(described_class.find_with_jwt(invalid_token)).to be_nil
      end
    end

    context "when the token is expired" do
      let!(:expired_token) do
        JWT.encode({ user_id: user.id, exp: 1.second.ago.to_i }, secret_key, "HS256")
      end

      it "does not find a user" do
        expect(described_class.find_with_jwt(expired_token)).to be_nil
      end
    end
  end

  describe ".without_soft_destroyed" do
    let!(:users) { create_list(:user, 3) }
    context "when there are no soft destroyed users" do
      it "returns all users" do
        expect(described_class.without_soft_destroyed).to eq users
      end
    end

    context "when there are soft destroyed users" do
      let!(:soft_destroyed_user) { create(:user, deleted_at: Time.current) }

      it "returns only users that are not soft destroyed" do
        expect(described_class.without_soft_destroyed).to eq users
      end
    end
  end

  describe ".soft_destroy!" do
    let!(:user) { create(:user) }
    context "fill in the deleted_at column" do
      it "is soft destroyed" do
        user.soft_destroy!
        expect(user.deleted_at).not_to be_nil
      end
    end
  end
end
