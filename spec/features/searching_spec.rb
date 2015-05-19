require 'rails_helper'

feature 'Searching through the site' do
  given!(:question1) { create :question, body: 'test' }
  given!(:question2) { create :question }
  given!(:answer) { create :answer, body: 'test', question: question2 }

  context 'when they search globally' do
    scenario 'finds all questions with given text', js: true do
      ThinkingSphinx::Test.run do
        visit root_path

        fill_in 'q', with: 'test'
        click_on 'Find'

        expect(page).to have_selector('.list-group-item', count: 2)
      end
    end
  end

  context 'when they search with conditions' do
    scenario 'finds all questions with given text', js: true do
      ThinkingSphinx::Test.run do
        visit root_path

        select('questions', from: 'conditions')
        fill_in 'q', with: 'test'
        click_on 'Find'

        expect(page).to have_selector('.list-group-item', count: 1)
      end
    end
  end
end