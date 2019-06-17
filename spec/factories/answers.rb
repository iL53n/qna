FactoryBot.define do
  sequence :body do |n|
    "Answer_#{n}_body"
  end

  factory :answer do
    body
    question { nil }
    
    trait :invalid do
      body { nil }
    end
  end
end
