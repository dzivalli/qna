require 'rails_helper'

feature 'Authenticated user can delete only own questions and answers' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }


  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Delete own question' do
    user.questions << question

    log_in user

    visit question_path(question)

    expect { click_on 'Delete' }.to change(Question, :count).by -1
    expect(current_path).to eq questions_path
  end

  scenario 'Delete someone question' do
    user2.questions << question

    log_in user

    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

  scenario 'Delete own answer' do
    user.questions << question
    user.answers << answer

    log_in user

    visit question_path(question)

    expect { click_on 'Delete answer' }.to change(question.answers, :count).by -1
  end

  scenario 'Delete someones answer' do
    user2.questions << question
    user2.answers << answer

    log_in user

    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end