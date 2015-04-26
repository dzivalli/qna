require 'rails_helper'

feature 'Resulting votes for answer' do
  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }
  given(:user_3) { create(:user) }
  given(:user_4) { create(:user) }
  given(:question) { create(:question)}
  given(:answer) { create(:answer, question: question)}

  background do
    vote_up_by user_1, data_id(answer)
    vote_up_by user_2, data_id(answer)
    vote_up_by user_3, data_id(answer)
    vote_down_by user_4, data_id(answer)
  end

  scenario 'it should show difference between positive and negative votes', js: true do
    visit question_path(question)

    within "#{data_id(answer)} .score" do
      expect(page).to have_content '2'
    end
  end
end