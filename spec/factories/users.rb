FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "test_user_#{n}" }
    sequence(:uid) {|n| "uuid_#{n}" }
    sequence(:email) {|n| "email_#{n}@example.com" }
    sequence(:image) {|n| "image_key_#{n}" }
    role { 1 }
  end
end
