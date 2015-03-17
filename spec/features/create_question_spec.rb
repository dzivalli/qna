require 'rails_helper'

feature 'Create question', type: :feature do
  scenario 'User create question with valid data' do
    visit new_question_path
    fill_in 'question_title', with: 'www'
    fill_in 'question_body', with: 'eee'
    click_on 'Submit'

    expect(page).to have_content 'www'
    expect(page).to have_content 'eee'
    expect(page).to have_content 'Question was created'

  end

  scenario 'User create question with invalid data' do
    visit new_question_path
    click_on 'Submit'

    expect(page).to have_content 'Please, check input data'
  end
end