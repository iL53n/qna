require 'rails_helper'

feature 'User can votes for the answer', %q{
    In order to evaluate the answer
    As a user
    I would like to able to vote for the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "All user can see the rating of answers", js: true do
    sign_in(create(:user))
    visit question_path(question)

    within ".answers > .answer_#{answer.id}" do
      click_link 'Up'
      expect(page).to have_content '1'
    end

    click_on 'Sign out'

    visit question_path(question)
    within ".answers > .answer_#{answer.id}" do
      expect(page).to have_content '1'
    end
  end

  scenario "Author can't vote for him answer" do
    sign_in(user)
    visit question_path(question)

    within ".answers > .answer_#{answer.id}" do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Cancel'
    end
  end

  describe "Not author", js: true do
    background do
      sign_in(create(:user))
      visit question_path(question)
      within(".answers > .answer_#{answer.id}") { click_link 'Up' }
    end

    scenario "can vote" do
      within ".answers > .answer_#{answer.id}" do
        expect(page).to have_content '1'
      end
    end

    scenario "can vote only once" do
      within ".answers > .answer_#{answer.id}" do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario "can cancel the vote" do
      within ".answers > .answer_#{answer.id}" do
        click_link 'Cancel'
        expect(page).to have_content '0'
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
      end
    end
  end
end
