require 'rails_helper'

feature 'Create answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }


  scenario 'Logged user create answer', js: true do
    log_in user

    visit question_path(question)

    fill_in 'answer_body', with: 'www'
    click_on 'Submit'

    # expect(page).to have_content 'Answer was added'
    expect(page).to have_content 'www'
  end

  scenario 'Unauthenticated user create answer' do
    visit question_path(question)

    fill_in 'answer_body', with: 'www'
    click_on 'Submit'

    expect_sign_in_page
  end
end
