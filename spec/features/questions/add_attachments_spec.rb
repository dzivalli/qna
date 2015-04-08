require 'rails_helper'

feature 'Add attachment to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}


  background { log_in user }

  context 'when question is created' do
  background do
    visit question_path(question)

    add_files('.question',
              "#{Rails.root}/spec/rails_helper.rb",
              "#{Rails.root}/spec/spec_helper.rb")
  end

    scenario 'Owner can attach files to his question', js: true do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'Owner can delete attached files', js: true do
      page.find('.edit').click

      page.find("[data-file='spec_helper.rb'] .delete-attachment").click
      page.find("[data-file='rails_helper.rb'] .delete-attachment").click

      expect(page).to_not have_content 'spec_helper.rb'
      expect(page).to_not have_content 'rails_helper.rb'

      click_on('Save')

      expect(page).to_not have_link 'spec_helper.rb'
      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario 'User create question with attached files', js: true do
    visit new_question_path

    fill_in 'Title', with: 'www'
    fill_in 'Text', with: 'eee'
    attach_file 'question[attachments_attributes][0][file]',
                "#{Rails.root}/spec/rails_helper.rb"
    attach_file 'question[attachments_attributes][1][file]',
                "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Submit'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end