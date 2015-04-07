require 'rails_helper'

feature 'Owner can attach files to his answer and delete them' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 5, question: question) }

  background do
    @answer = answers[3]
    user.answers << @answer

    log_in user

    visit question_path(question)

    add_files("[data-id='#{@answer.id}']",
              "#{Rails.root}/spec/rails_helper.rb",
              "#{Rails.root}/spec/spec_helper.rb")
  end

  scenario 'Attach files', js: true do
    within "[data-id='#{@answer.id}']" do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Delete files', js: true do
    within "[data-id='#{@answer.id}']" do
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