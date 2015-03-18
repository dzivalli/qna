require 'rails_helper'

feature 'Only logged user can create questions and answers' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Logged user create question' do
    log_in user
    attrs = attributes_for :question
    visit new_question_path

    fill_in 'question_title', with: attrs[:title]
    fill_in 'question_body', with: attrs[:body]

    click_on 'Submit'

    expect(page).to have_content 'Question was created'
    expect(Question.find_by_title(attrs[:title])).to_not be_nil
  end

  scenario 'Unauthenticated user cannot create question' do
    visit new_question_path

    expect_sign_in_page
  end

  scenario 'Logged user create answer' do
    log_in user

    visit question_path(question)

    fill_in 'answer_body', with: 'www'
    click_on 'Submit'

    expect(page).to have_content 'Answer was added'
    expect(Answer.find_by_body('www')).to_not be_nil
  end

  scenario 'Unauthenticated user create answer' do
    visit question_path(question)

    fill_in 'answer_body', with: 'www'
    click_on 'Submit'

    expect_sign_in_page
  end
end