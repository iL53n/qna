require 'rails_helper'

feature 'User can destroy an answer', %q{
    In order to hide an incorrect answer
    As an authenticated user
    I'd like to be able to destroy an answer
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Author destroy the answer', js: true do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content answer.body

    page.accept_confirm do
      click_link 'Delete answer'
    end
    expect(page).to_not have_content answer.body
  end

  scenario "Not author can't destroy the answer" do
    sign_in(user_not_author)

    visit question_path(question)

    expect(page).to_not have_link answer_path(answer)
  end

  scenario 'Unauthenticated user tries to destroy an answer' do
    visit question_path(question)

    expect(page).to_not have_link answer_path(answer)
  end
end
