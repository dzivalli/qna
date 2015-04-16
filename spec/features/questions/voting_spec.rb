require 'rails_helper'

feature 'Question voting' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'when user is authorized' do
    background do
      log_in user

      visit question_path(question)
    end

    scenario 'he can vote for question', js: true do
      within '.question' do
        page.find('.up').click

        within '.score' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'he can vote against question', js: true do
      within '.question' do
        page.find('.down').click

        within '.score' do
          expect(page).to have_content '-1'
        end
      end
    end

  end

  scenario 'Unauthorized user cannot vote for question' do
    visit question_path(question)

    expect(page).to_not have_selector '.up'
    expect(page).to_not have_selector '.up'
  end
end