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
    expect(page).to have_content 'Question was created'

  end

  scenario 'User create question with invalid data' do
    log_in user

    visit new_question_path
    click_on 'Submit'

    expect(page).to have_content 'Please, check input data'
  end

  scenario 'User create question with attached files', js: true do
    log_in user

    visit new_question_path

    fill_in 'Title', with: 'www'
    fill_in 'Text', with: 'eee'
    attach_file 'question[attachments_attributes][0][file]',
                "#{Rails.root}/spec/rails_helper.rb"
    attach_file 'question[attachments_attributes][1][file]',
                "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Submit'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end