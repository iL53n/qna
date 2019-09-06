require 'rails_helper'

feature 'User can votes for the question', %q{
    In order to evaluate the question
    As a user
    I would like to able to vote for the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario "All user can see the rating of questions", js: true do
    sign_in(create(:user))
    visit question_path(question)

    within ".question .question_votes" do
      click_link 'Up'
      expect(page).to have_content '1'
    end

    find('.dropdown-toggle').click
    click_on 'Sign out'

    visit question_path(question)
    within ".question .question_votes" do
      expect(page).to have_content '1'
    end
  end

  scenario "Author can't vote for him question" do
    sign_in(user)
    visit question_path(question)

    within ".question .question_votes" do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Cancel'
    end
  end

  describe "Not author", js: true do
    background do
      sign_in(create(:user))
      visit question_path(question)
      within(".question .question_votes") { click_link 'Up' }
    end

    scenario "can vote" do
      within ".question .question_votes" do
        expect(page).to have_content '1'
      end
    end

    scenario "can vote only once" do
      within ".question .question_votes" do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario "can cancel the vote" do
      within ".question .question_votes" do
        click_link 'Cancel'
        expect(page).to have_content '0'
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
      end
    end
  end
end
