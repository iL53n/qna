require 'rails_helper'

feature 'User can show him rewards list', %q{
    To see the results of my answers.
    As a user
    I would like to see all my rewards for answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:rewards) { create_list(:reward, 3, question: question, user: user) }

  scenario 'User see all him rewards for answers ' do
    sign_in(user)
    visit rewards_path

    rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
    end
  end

  scenario "User can't see another users rewards" do
    sign_in(create(:user))
    visit rewards_path

    rewards.each do |reward|
      expect(page).to_not have_content reward.question.title
      expect(page).to_not have_content reward.title
    end
  end
end

