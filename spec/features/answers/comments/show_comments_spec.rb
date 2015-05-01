require 'rails_helper'

feature 'Show answer comments' do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer, body: 'www') }

  scenario 'Show answer with his comments' do
    visit question_path(question)

    within data_id(answer) do
      expect(page).to have_content 'www'
    end
  end
end
