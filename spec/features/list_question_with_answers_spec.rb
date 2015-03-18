require 'rails_helper'

feature 'List question with all answers' do
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 5)}

  scenario 'list question with answers' do
    question.answers << answers

    visit question_path(question)

    expect(page).to have_selector('.list-group-item', count: answers.count)
  end
end