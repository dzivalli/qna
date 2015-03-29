require 'rails_helper'

feature 'Create answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }


  scenario 'Logged user create answer', js: true do
    log_in user

    visit question_path(question)

    fill_in 'Text', with: 'www'
    click_on 'Submit'

    expect(page).to have_content 'www'
  end


  scenario 'unauthorized users cant see answer form' do
    visit question_path(question)

    expect(page).to_not have_selector '#new_answer'
  end
end
