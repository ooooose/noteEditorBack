FactoryBot.define do
  factory :comment do
    association :user
    association :picture
    sequence(:body) {|n| "comment body #{n}" }
  end
end
