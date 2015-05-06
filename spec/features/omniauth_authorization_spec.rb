require 'rails_helper'

feature 'Authorization with omniauth providers' do
  context 'when provider is facebook' do
    facebook_mock

    scenario 'via facebook' do
      visit new_user_session_path
      click_on 'via facebook'

      expect(current_path).to eq root_path
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end

  context 'when provider is twitter' do
    twitter_mock
    given(:user) { create :user, email: 'email@email.ru' }

    background do
      visit new_user_session_path
      click_on 'via twitter'
      fill_in 'Email', with: 'email@email.ru'
    end

    scenario 'via twitter with new email' do
      click_on 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

      open_email('email@email.ru')
      current_email.click_on 'Confirm my account'

      # devise recommend do not auto sign the user in after confirmation
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on 'via twitter'

      expect(current_path).to eq root_path
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    scenario 'via twitter with existed email' do
      user
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end