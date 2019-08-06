require 'rails_helper'

feature 'User can sign in with provider account', %q{
  In order to have several sign in options
  As a user
  I'd like to be able to sign in using provider account
} do

  %w[GitHub Facebook].each do |provider|
    background { visit new_user_session_path }

    scenario "User can sign in with #{provider} account" do
      mock_auth_hash(provider)

      silence_omniauth { click_on "Sign in with #{provider}" }

      expect(page).to have_content "Successfully authenticated from #{provider} account."
      expect(page).to have_content 'user@mock.com'
      expect(page).to have_link 'Sign out'
    end

    scenario "User can not sign in with #{provider} with invalid data" do
      invalid_mock_auth_hash(provider)
      silence_omniauth { click_on "Sign in with #{provider}" }

      expect(page).to have_content "Could not authenticate you from #{provider} because \"Invalid credentials\"."
      expect(page).to have_link 'Sign in'
      expect(page).to_not have_content 'user@mock.com'
      expect(page).to_not have_link 'Sign out'
    end
  end
end