require 'rails_helper'

feature 'User add comments to question' do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  context 'when the user is authenticated' do
    scenario 'add comment', js: true do
      log_in user
      visit question_path(question)

      within '.question .comments' do
        click_on 'Add comment'
        fill_in 'Text', with: 'comment 1'
        click_on 'Save'

        expect(page).to have_content 'comment 1'
      end
    end

    scenario 'add comment with empty body', js: true do
      log_in user
      visit question_path(question)

      within '.question .comments' do
        click_on 'Add comment'
         click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end


  scenario 'unauthorized user can add comment', js: true do
    visit question_path(question)

    within '.question .comments' do
      expect(page).to_not have_content 'Add comment'
    end
  end
end