FactoryBot.define do
  sequence :title do |n|
    "Question_#{n}_title"
  end

  factory :question do
    title
    body { "MyText" }

    trait :add_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :invalid do
      title { nil }
      body { "invalid_obj" } #mark
    end
  end
end
