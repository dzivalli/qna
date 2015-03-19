require 'rails_helper'

feature 'Create question' do
  given(:user) { create(:user) }

  scenario 'Logged user create question' do
    log_in user
    visit new_question_path

    fill_in 'question_title', with: 'www'
    fill_in 'question_body', with: 'eee'

    click_on 'Submit'

    expect(page).to have_content 'www'
    expect(page).to have_content 'eee'
  end

  scenario 'Unauthenticated user create question' do
    visit new_question_path

    expect_sign_in_page
  end

end