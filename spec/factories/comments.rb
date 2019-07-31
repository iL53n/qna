FactoryBot.define do
  factory :comment do
    body { 'Comment' }

    trait :invalid do
      body { nil }
    end
  end
end