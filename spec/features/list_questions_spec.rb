require 'rails_helper'

feature 'List all questions' do
  given!(:questions) { create_list(:question, 5) }

  scenario 'user should see all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end