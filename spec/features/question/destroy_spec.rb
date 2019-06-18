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
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario "Not author can't destroy the question" do
    sign_in(user_not_author)

    visit question_path(question)

    expect(page).to_not have_link question_path(question)
  end

  scenario 'Unauthenticated user tries to destroy a question' do
    visit question_path(question)

    expect(page).to_not have_link question_path(question)
  end
end

