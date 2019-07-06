require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:url) { 'https://gist.github.com/iL53n/0acd40b1345c1bafa854c6efb8a93a47' }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'edits his question' do
      within '.question' do
        fill_in 'Title', with: 'Title_edited'
        fill_in 'Body', with: 'Body_edited'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'Title_edited'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Body_edited'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his question with attached files' do
      within '.question' do
        fill_in 'Title', with: 'Title_edited'
        fill_in 'Body', with: 'Body_edited'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'can add link when editing answer' do
      within '.question' do
        click_on 'Add link'
        fill_in 'Link name', with: 'New link'
        fill_in 'Url', with: url
        click_on 'Save'

        expect(page).to have_link 'New link', href: url
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    sign_in(user_not_author)

    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end