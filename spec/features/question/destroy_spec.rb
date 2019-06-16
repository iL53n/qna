require 'rails_helper'

feature 'User can destroy a question', %q{
    In order to hide an incorrect question
    As an authenticated user
    I'd like to be able to destroy a question
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given(:question) { create(:question, user: user)}

  scenario 'Author destroy the question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'The question are destroyed'
  end

  scenario "Not author can't destroy the question" do
    sign_in(user_not_author)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Only author can destroy a question'
  end

  scenario 'Unauthenticated user tries to destroy a question' do
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

