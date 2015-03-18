require 'rails_helper'

feature 'User authorization and registration' do
  given(:user) { create(:user) }

  scenario 'sign in with valid data' do
    log_in(user)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'sign in with invalid data' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12333'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
  end

  scenario 'sign out' do
    log_in(user)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed in successfully.'
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'registration' do
    email = 'ya@ya.ru'
    password = '12345678'
    visit new_user_registration_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(User.find_by_email(email)).to_not be_nil
  end
end