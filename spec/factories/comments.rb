FactoryBot.define do
  factory :comment do
    body { 'Comment' }
    user

    trait :invalid do
      body { nil }
    end
  end
end