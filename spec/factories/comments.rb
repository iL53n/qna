FactoryBot.define do
  factory :comment do
    body
    user

    trait :invalid do
      body { nil }
    end
  end
end