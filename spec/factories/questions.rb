FactoryBot.define do
  sequence :title do |n|
    "Question_#{n}_title"
  end

  factory :question do
    title
    user
    body { "MyText" }

    trait :add_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :invalid do
      title { nil }
      body { "invalid_obj" } #mark
    end

    trait :created_at_yesterday do
      created_at { Date.today - 1 }
    end

    trait :created_at_more_yesterday do
      created_at { Date.today - 2 }
    end
  end
end
