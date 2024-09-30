FactoryBot.define do
  factory :theme do
    sequence(:title) { |n| "theme#{n}" }
  end
end
