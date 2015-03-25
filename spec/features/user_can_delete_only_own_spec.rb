require 'rails_helper'

feature 'Deleting only own questions and answers' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Delete own question' do
    user.questions << question

    log_in user

    visit question_path(question)

    within '.question' do
      page.find('.delete').click
    end

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(current_path).to eq questions_path
  end

  scenario 'Delete someone question' do
    user2.questions << question

    log_in user

    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

  scenario 'Delete own answer', js: true do
    user.questions << question
    user.answers << answer

    log_in user

    visit question_path(question)

    within "[data-id='#{answer.id}']" do
      page.find('.delete').click
    end

    expect(page).to_not have_selector "[data-id='#{answer.id}']"
  end

  scenario 'Delete someones answer', js: true do
    user2.questions << question
    user2.answers << answer

    log_in user

    visit question_path(question)

    within "[data-id='#{answer.id}']" do
      expect(page).to_not have_selector '.delete'
    end
  end
end