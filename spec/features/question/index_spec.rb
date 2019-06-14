require 'rails_helper'

feature 'User can show questions list', %q{
    In order to find the necessary question
    As a user
    I'd like to see all the questions list
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  background do
    sign_in(user)
    visit questions_path
  end

  scenario 'User see all the questions list' do
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end

