require 'rails_helper'

feature 'Edit question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  before { log_in user}

  describe 'User can edit own question' do
    before do
      user.questions << question
      visit question_path(question)
    end

    scenario 'with valid params', js: true do
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

    scenario 'with invalid params', js: true do
      within '.question' do
        page.find('.edit').click

        fill_in 'question_title', with: ''
        fill_in 'question_body', with: ''

        click_on 'Save'
      end

      within '.question .errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'User cannot edit someones question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_selector '.edit'
    end
  end
end