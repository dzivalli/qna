require 'rails_helper'

feature 'Resulting votes for question' do
  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }
  given(:user_3) { create(:user) }
  given(:user_4) { create(:user) }
  given(:question) { create(:question)}

  background do
    vote_up_by user_1, '.question'
    vote_up_by user_2, '.question'
    vote_up_by user_3, '.question'
    vote_down_by user_4, '.question'
  end

  scenario 'it should show difference between positive and negative votes', js: true do
    visit question_path(question)

    within '.question .score' do
      expect(page).to have_content '2'
    end
  end
end