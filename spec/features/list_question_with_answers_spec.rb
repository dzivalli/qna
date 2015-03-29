require 'rails_helper'

feature 'List question with all answers' do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question)}

  before do
    answers.last.update best: true
    visit question_path(question)
  end

  scenario 'list question with answers' do
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'list best answer first' do
    element = first('.sign').native.to_s
    expect(element).to match(/fa-check-circle/)
  end
end