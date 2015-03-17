require 'rails_helper'

feature 'List all questions' do
  let(:questions) { create_list(:question, 5) }

  scenario 'user should see all questions' do
    questions
    visit questions_path

    expect(page).to have_selector '.list-group-item', count: questions.count
  end
end