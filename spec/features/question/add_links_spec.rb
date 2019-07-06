require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url_1) { 'https://gist.github.com/iL53n/0acd40b1345c1bafa854c6efb8a93a47' }
  # given(:gist_url_2) { 'https://gist.github.com/iL53n/3c8114658970af2572879f69a0727cb0' }

  scenario 'User add links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'
    fill_in 'Link name', with: 'My gist 1'
    fill_in 'Url', with: gist_url_1

    # click_on 'Add link'
    # fill_in 'Link name', with: 'My gist 2'
    # fill_in 'Url', with: gist_url_2

    click_on 'Ask'

    expect(page).to have_link 'My gist 1', href: gist_url_1
    # expect(page).to have_link 'My gist 2', href: gist_url_2
  end
end