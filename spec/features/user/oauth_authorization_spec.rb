require 'rails_helper'

feature 'User can sign in with provider account', %q{
  In order to have several sign in options
  As a user
  I'd like to be able to sign in using provider account
} do

  scenario 'User can sign in with provider account' do
    visit new_user_session_path
    mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from GitHub account.'
    expect(page).to have_content 'user@mock.com'
    expect(page).to have_link 'Sign out'
  end

  scenario 'User can not sign in with invalid data' do
    visit new_user_session_path
    invalid_mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content "Could not authenticate you from GitHub because \"Invalid credentials\"."
    expect(page).to have_link 'Sign in'
    expect(page).to_not have_content 'user@mock.com'
    expect(page).to_not have_link 'Sign out'
  end
end