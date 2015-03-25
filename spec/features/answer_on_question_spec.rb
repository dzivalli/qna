require 'rails_helper'

feature 'User can answer on question' do
  given!(:question) { create(:question) }
  given(:user) { create(:user) }

  before do
    log_in user

    visit question_path(question)
  end

  scenario 'answer with valid data', js: true do
    fill_in 'answer_body', with: 'www'
    click_on 'Submit'

    expect(page).to have_content 'www'
  end

  scenario 'answer with invalid data', js: true do
    click_on 'Submit'

    within 'form#new_answer' do
      expect(page).to have_content "Body can't be blank"
    end
  end
end