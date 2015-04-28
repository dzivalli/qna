require 'rails_helper'

feature 'Show question' do
  given(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question, body: 'www') }

  scenario 'Show question with his comments' do
    visit question_path(question)

    within '.question .comments' do
      expect(page).to have_content 'www'
    end
  end
end
