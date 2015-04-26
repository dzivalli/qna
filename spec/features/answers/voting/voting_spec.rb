require 'rails_helper'

feature 'User can vote for answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'when user is authorized' do
    background do
      log_in user

      visit question_path(question)
    end

    scenario 'he can vote for answer', js: true do
      within data_id(answer) do
        within '.score' do
          page.find('.up').click

          expect(page).to have_content 1
        end
      end
    end

    scenario 'he can vote against answer', js: true do
      within data_id(answer) do
        within '.score' do
          page.find('.down').click

          expect(page).to have_content -1
        end
      end
    end
  end

  scenario 'unauthorized user cannot vote', js: true do
    visit question_path(question)

    within data_id(answer) do
      expect(page).to_not have_selector '.up'
      expect(page).to_not have_selector '.down'
    end
  end
end