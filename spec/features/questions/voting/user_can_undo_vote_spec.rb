require 'rails_helper'

feature 'User can vote only one time for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    log_in user

    visit question_path(question)
  end

  scenario 'Undo vote for question after voting for', js: true do
    within '.question' do
      expect_vote_to_undo_after_click_on_up
    end
  end

  scenario 'Undo vote for question after voting against', js: true do
    within '.question' do
      expect_vote_to_undo_after_click_do_down
    end
  end
end