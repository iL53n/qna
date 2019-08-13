require 'rails_helper'

feature 'User can sign in with provider account', %q{
  In order to have several sign in options
  As a user
  I'd like to be able to sign in using provider account
} do

  background { visit new_user_session_path }

  describe 'With email' do
    %w[GitHub Facebook Vkontakte].each do |provider|

      scenario "User can sign in with #{provider} account with correct data" do
        mock_auth_hash(provider)
        silence_omniauth { click_on "Sign in with #{provider}" }

        expect(page).to have_content "Successfully authenticated from #{provider.capitalize} account."
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

  describe 'Without email' do
    scenario 'New user can sign in with Twitter account with valid data' do
      mock_auth_twitter

      silence_omniauth { click_on 'Sign in with Twitter' }
      expect(page).to have_content 'Enter your email for confirmation'
      fill_in 'Email', with: 'user@test.com'
      click_on 'Send email'

      expect(page).to have_content 'Email confirmation instructions send to user@test.com'

      open_email 'user@test.com'
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      expect(page).to have_content 'user@mail.com'
      expect(page).to have_link 'Sign out'
    end
  end
end