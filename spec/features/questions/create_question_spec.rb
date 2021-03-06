require 'rails_helper'

feature 'Create question', type: :feature do
  given(:user) { create(:user) }

  scenario 'User create question with valid data' do
    log_in user

    visit new_question_path
    fill_in 'Title', with: 'www'
    fill_in 'Text', with: 'eee'
    click_on 'Submit'

    expect(page).to have_content 'www'
    expect(page).to have_content 'eee'
    expect(page).to have_content 'Question was successfully created'

  end

  scenario 'User create question with invalid data' do
    log_in user

    visit new_question_path
    click_on 'Submit'

    expect(page).to have_content 'Question could not be created'
  end
end