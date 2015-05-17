require 'rails_helper'

feature 'Unsubscription' do
  given(:user) { create :user }
  given(:question) { create :question }
  given!(:notification) { create :notification, question: question, user: user }

  scenario 'click on unsubscribe if user is authorized', js: :true do
    log_in user
    visit question_path(question)

    within '.question.box' do
      click_on 'unsubscribe'

      expect(page).to have_selector(:link_or_button, 'subscribe')
    end
  end

  scenario 'there is no unsubscribe button if user is not authorized', js: :true do
    visit question_path(question)

    within '.question.box' do
      expect(page).to_not have_selector(:link_or_button, 'unsubscribe')
    end
  end
end