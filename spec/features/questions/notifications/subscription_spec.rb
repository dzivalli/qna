require 'rails_helper'

feature 'Subscription' do
  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'click on subscribe if user is authorized', js: :true do
    log_in user
    visit question_path(question)

    within '.question.box' do
      click_on 'subscribe'

      expect(page).to have_selector(:link_or_button, 'unsubscribe')
    end
  end

  scenario 'there is no subscribe button if user is not authorized', js: :true do
    visit question_path(question)

    within '.question.box' do
      expect(page).to_not have_selector(:link_or_button, 'subscribe')
    end
  end
end