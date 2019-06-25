require 'rails_helper'

feature 'User can choice best answer', %q{
  In order to estimate answers
  As an author of the answer
  I'd like to be able to mark the best answer
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user can not choice best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best Answer'
  end

  scenario 'Authenticated user choice best answer',js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Best answer'

    within '.answers' do
      expect(page).to have_content 'TheBest'
    end
  end

  scenario "Authenticated user tries to choose the best answer for another user’s question." do
    sign_in(user_not_author)

    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end