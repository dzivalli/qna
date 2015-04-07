require 'rails_helper'

feature 'Add attachment to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}


  background do
    log_in user

    visit question_path(question)

    add_files("#{Rails.root}/spec/rails_helper.rb",
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