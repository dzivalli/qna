require 'rails_helper'

feature 'User can vote only one time' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    log_in user

    visit question_path(question)
  end

  scenario 'Get error after second click on up button', js: true do
    within '.question' do
      2.times do
        page.find('.up').click

        within '.score' do
          expect(page).to have_content '1'
        end
      end
    end
  end

  scenario 'Get error after second click on down button', js: true do
    within '.question' do
      2.times do
        page.find('.down').click

        within '.score' do
          expect(page).to have_content '-1'
        end
      end
    end
  end
end