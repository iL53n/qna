require 'rails_helper'

feature 'User can sign in with provider account', %q{
  In order to have several sign in options
  As a user
  I'd like to be able to sign in using provider account
} do

  background { visit new_user_session_path }

  describe 'Without email' do
    %w[GitHub Facebook Vkontakte].each do |provider|

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

  describe 'With email' do
    scenario 'New user try to sign in with Twitter account' do
      mock_auth_hash(:twitter)

      silence_omniauth { click_on "Sign in with Twitter" }
      expect(page).to have_link 'Need your email'
      fill_in 'email', with: 'user@test.com'
      click_on 'Save'

      expect(page).to have_content 'You have to confirm your email address before continuing'
      open_email 'user@mail.ru'
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      visit user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from Twitter account'
      expect(page).to have_content 'user@mail.com'
      expect(page).to have_link 'Sign out'
    end

    # scenario 'Exiting user try to sign in with Twitter account' do
    #   mock_auth_hash(:twitter)
    #
    #   silence_omniauth { click_on "Sign in with Twitter" }
    #   expect(page).to have_link 'Need your email'
    #   fill_in 'email', with: 'user@test.com'
    #   click_on 'Save'
    #
    #   expect(page).to have_content 'Successfully authenticated from Twitter account'
    #   expect(page).to have_content 'user@mail.com'
    #   expect(page).to have_link 'Sign out'
    # end
  end
end