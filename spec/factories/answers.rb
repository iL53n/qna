FactoryBot.define do
  sequence :body do |n|
    "Answer_#{n}_body"
  end

  factory :answer do
    body
    question { nil }

    trait :add_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end
    
    trait :invalid do
      body { nil }
    end
  end
end
