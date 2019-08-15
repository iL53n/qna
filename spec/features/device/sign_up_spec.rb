require 'rails_helper'

feature 'User can sign up', %q{
    In order to be able to sign in
    As an guest
    I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  describe 'Unregistered user ' do
    scenario 'tries to sign up' do # ToDo: add email confirm
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'tries to sign up with errors' do
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: '123456789'
      fill_in 'Password confirmation', with: '12345'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
