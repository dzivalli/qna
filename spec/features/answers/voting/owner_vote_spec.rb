require 'rails_helper'

feature 'Owner voting' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }


  background do
    log_in user

    visit question_path(question)
  end

  scenario 'answer owner cannot vote for it', js: true do
    within data_id(answer) do
      page.find('.up').click

      within '.score' do
        expect(page).to have_content '0'
      end
    end
  end

  scenario 'answer owner cannot vote against it', js: true do
    within data_id(answer) do
      page.find('.down').click

      within '.score' do
        expect(page).to have_content '0'
      end
    end
  end
end