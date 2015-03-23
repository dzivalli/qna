require 'rails_helper'

feature 'Edit question' do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { log_in user}

  scenario 'User can edit own question', js: true do
    user.questions << question

    visit question_path(question)

    within '.question' do
      page.find('.edit').click

      fill_in 'question_title', with: 'qwe'
      fill_in 'question_body', with: 'ewq'

      click_on 'Save'

      within '.panel-question' do
        expect(page).to have_content 'qwe'
        expect(page).to have_content 'ewq'
      end
    end
  end

  scenario 'User edit question with wrong params', js: true do
    user.questions << question

    visit question_path(question)

    within '.question' do
      page.find('.edit').click

      fill_in 'question_title', with: ''
      fill_in 'question_body', with: ''

      click_on 'Save'
    end

    within '.question-errors' do
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'User cannot edit someones question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_selector '.edit'
    end
  end
end