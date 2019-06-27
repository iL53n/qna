require 'rails_helper'

feature 'User can create an answer for the question', %q{
    In order to help other users
    As an authenticated user
    I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user ', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'to answer the question' do
      fill_in 'Your answer', with: 'Text answer'
      click_on 'Post Your Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Text answer'
      end
    end

    scenario 'tries to answer the question with errors' do
      click_on 'Post Your Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'to answer the question qith attached files' do
      fill_in 'Your answer', with: 'Text answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post Your Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Post Your Answer'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
