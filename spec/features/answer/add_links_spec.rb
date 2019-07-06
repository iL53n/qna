require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As a answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url_1) { 'https://gist.github.com/iL53n/0acd40b1345c1bafa854c6efb8a93a47' }
  # given(:gist_url_2) { 'https://gist.github.com/iL53n/3c8114658970af2572879f69a0727cb0' }

  scenario 'User add links when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Text answer'

    click_on 'Add link'
    fill_in 'Link name', with: 'My gist 1'
    fill_in 'Url', with: gist_url_1

    # click_on 'Add link'
    # fill_in 'Link name', with: 'My gist 2'
    # fill_in 'Url', with: gist_url_2

    click_on 'Post Your Answer'

    within '.answers .answer_links' do
      expect(page).to have_link 'My gist 1', href: gist_url_1
      # expect(page).to have_link 'My gist 2', href: gist_url_2
    end
  end
end