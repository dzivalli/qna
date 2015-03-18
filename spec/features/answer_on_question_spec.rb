require 'rails_helper'

feature 'User can answer on question' do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  before do
    log_in user

    question
    visit question_path(question)
  end

  scenario 'answer with valid data' do
    fill_in 'answer_body', with: 'www'
    click_on 'Submit'

    expect(page).to have_content 'Answer was added'
    expect(page).to have_content 'www'
  end

  scenario 'answer with invalid data' do
    click_on 'Submit'

    expect(page).to have_content 'Please, fill in body area'
  end
end