FactoryBot.define do
  factory :reward do
    sequence :title do |n|
      "Reward_#{n}"
    end
    # title {'Reward_title'}
    image { fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'qna_logo.png'), 'qna_logo.png') }
  end
end