require 'rails_helper'

feature 'User can destroy an answer', %q{
    In order to hide an incorrect answer
    As an authenticated user
    I'd like to be able to destroy an answer
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question)}

  scenario 'Author destroy the answer' do
    sign_in(user)

    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'The answer are destroyed'
  end

  scenario "Not author can't destroy the answer" do
    sign_in(user_not_author)

    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'Only author can destroy an answer'
  end

  scenario 'Unauthenticated user tries to destroy an answer' do
    visit answer_path(answer)

    click_on 'Delete answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

