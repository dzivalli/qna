require 'rails_helper'

feature 'Owner can attach files to his answer and delete them' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    log_in user

    visit question_path(question)
  end

  context 'when answer is created' do
    background do
      add_files("[data-id='#{answer.id}']",
                "#{Rails.root}/spec/rails_helper.rb",
                "#{Rails.root}/spec/spec_helper.rb")
    end

    scenario 'Attach files', js: true do
      within "[data-id='#{answer.id}']" do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Delete files', js: true do
      within "[data-id='#{answer.id}']" do
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
  end

  scenario 'create answer with attached files', js: true do
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