FactoryBot.define do
  factory :picture do
    sequence(:image_url) { |n| "https://example.com/picture#{n}.png" }
    frame_id { 0 }
    association :user
    association :theme
  end
end
