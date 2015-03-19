require 'rails_helper'

feature 'List question with all answers' do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question,)}

  scenario 'list question with answers' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end