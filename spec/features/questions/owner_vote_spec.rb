require 'rails_helper'

feature 'Owner voting' do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  background do
    log_in user

    visit question_path(question)
  end

  scenario 'question owner cannot vote for it', js: true do
    within '.question' do
      page.find('.up').click

      within '.score' do
        expect(page).to have_content '0'
      end
    end
  end

  scenario 'question owner cannot vote against it', js: true do
    within '.question' do
      page.find('.down').click

      within '.score' do
        expect(page).to have_content '0'
      end
    end
  end
end