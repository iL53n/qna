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
  given!(:answer_two) { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user can not choice best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best Answer'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'choice best answer for his question',js: true do
      within '.answers' do
        within ".answer_#{answer.id}" do
          click_on 'Best answer'
          expect(page).to have_content 'TheBest'
        end
      end
    end

    scenario 'change best answer for his question',js: true do
      within ".answers > .answer_#{answer.id}" do
        click_on 'Best answer'
        expect(page).to have_content 'TheBest'
      end

      within ".answers > .answer_#{answer_two.id}" do
        click_on 'Best answer'
        expect(page).to have_content 'TheBest'
      end

      within ".answers > .answer_#{answer.id}" do
        expect(page).to_not have_content 'TheBest'
      end

      expect(page.all('.answers').first).to have_content 'TheBest'
    end
  end

  scenario "Authenticated user tries to choose the best answer for another user’s question." do
    sign_in(user_not_author)

    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end