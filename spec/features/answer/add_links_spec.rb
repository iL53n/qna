require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As a answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/iL53n/0acd40b1345c1bafa854c6efb8a93a47' }
  given(:another_url) { 'https://google.com' }

  describe 'When user give an answer he adds', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Your answer', with: 'Text answer'
      click_on 'Add link'
    end

    scenario 'gist link' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Post Your Answer'

      expect(page).to have_content 'Hello, World!'
    end

    scenario 'another link' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: another_url

      click_on 'Post Your Answer'
      expect(page).to have_link 'Google', href: another_url
    end
  end
end
