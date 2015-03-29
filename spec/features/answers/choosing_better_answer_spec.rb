require 'rails_helper'

feature 'Author can choose the best answer for question' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:user2) { create(:user)}
  let!(:answer) { create(:answer, question: question, user: user2)}
  let!(:answer2) { create(:answer, question: question, user: user2)}

  scenario 'After selecting appears special sign near current answer and disappear from previous one', js: true do
    log_in user

    visit question_path(question)

    within data_id(answer) do
      page.find('.best').click
    end

    within data_id(answer2) do
      page.find('.best').click

      expect(page).to have_selector '.fa-check-circle'
    end

    expect(page).to have_selector '.fa-check-circle', count: 1
  end

  scenario 'Only author can see button to select', js: true do
    log_in user2

    visit question_path(question)

    within data_id(answer) do
      expect(page).to_not have_selector '.best'
    end
  end
end