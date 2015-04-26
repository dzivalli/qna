require 'rails_helper'

feature 'User can vote only one time for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    log_in user

    visit question_path(question)
  end

  scenario 'Get error after second click on up button', js: true do
    within '.question' do
      expect_change_vote_by_1_after_2_click_on_up
    end
  end

  scenario 'Get error after second click on down button', js: true do
    within '.question' do
      expect_change_vote_by_minus_1_after_2_click_on_up
    end
  end
end