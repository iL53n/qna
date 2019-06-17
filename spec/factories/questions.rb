FactoryBot.define do
  sequence :title do |n|
    "Question_#{n}_title"
  end

  factory :question do
    title
    body { "MyText" }

    trait :invalid do
      title { nil }
      body { "invalid_obj" } #mark
    end
  end
end
