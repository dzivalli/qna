require 'rails_helper'

feature 'Edit' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question)}

  before { log_in user }

  describe 'own answer' do
    before do
      user.answers << answer
      visit question_path(question)
    end

    scenario 'with valid params', js: true do
      within "[data-id='#{answer.id}']" do
        page.find('.edit').click

        fill_in 'answer_body', with: 'www'

        click_on 'Save'

        within '.answer-body' do
          expect(page).to have_content 'www'
        end
      end
    end

    scenario 'Own answer with wrong params', js: true do
      within "[data-id='#{answer.id}']" do
        page.find('.edit').click

        fill_in 'answer_body', with: ''

        click_on 'Save'

        within '.answer-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  scenario 'Someones answer', js: true do
    visit question_path(question)

    within "[data-id='#{answer.id}']" do
      expect(page).to_not have_selector('.edit')
    end
  end
end