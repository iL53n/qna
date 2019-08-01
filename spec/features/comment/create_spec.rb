require 'rails_helper'

feature 'User can create a comment for the question or answer', %q{
    In order to add info
    As an authenticated user
    I'd like to be able to comment the question or answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user creates comment for ', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'question' do
      within '.question' do
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Add Your Comment'

        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'answer' do
      within '.answers' do
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Add Your Comment'

        expect(page).to have_content 'Test comment'
      end
    end
  end

  describe 'Unauthenticated user tries to create comment for ', js: true do
    background do
      visit question_path(question)
    end

    scenario 'question' do
      within '.question' do
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Add Your Comment'

        expect(page).to_not have_content 'Test comment'
      end
    end

    scenario 'answer' do
      within '.answers' do
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Add Your Comment'

        expect(page).to_not have_content 'Test comment'
      end
    end
  end

  describe "Multiple sessions_appears on another user's page ", js: true do
    scenario "question's comment" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Your comment', with: 'Test comment'
          click_on 'Add Your Comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'Test comment'
        end
      end
    end

    scenario "answer's comment" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Your comment', with: 'Test comment'
          click_on 'Add Your Comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end
end

