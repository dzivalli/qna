require 'rails_helper'

feature 'User can answer on question' do
  given!(:question) { create(:question) }
  given(:user) { create(:user) }

  before do
    log_in user

    visit question_path(question)
  end

  scenario 'answer with valid data', js: true do
    fill_in 'Text', with: 'www'
    click_on 'Submit'

    expect(page).to have_content 'www'
  end

  scenario 'answer with invalid data', js: true do
    click_on 'Submit'

    within 'form#new_answer' do
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'answer with attached files', js: true do
    fill_in 'Text', with: 'www'

    attach_file 'answer[attachments_attributes][0][file]',
                "#{Rails.root}/spec/rails_helper.rb"
    attach_file 'answer[attachments_attributes][1][file]',
                "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Submit'

    within all('.list-group .box').last do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end